# Coach Review Feature — Flutter Implementation Spec

**Status:** Backend spec locked + pushed (Laravel commit `a535d3f` on branch `feature/flutter-mobile-backend-fixes`). Backend table + endpoints not yet implemented at runtime — this doc is the FE wire-up plan that ships in lockstep.

**Backend doc (canonical source):** `C:\laragon\www\hypercoach\docs\superpowers\flutter-issue-mapping-2026-05-04.md` Issue 13.

---

## What this feature is

Students who attended a coaching session can submit a one-shot, immutable review (1-5 star rating + optional comment). Reviews are tied to a specific session and a specific coach.

**Locked design rules:**

| Rule | Value |
|---|---|
| Rating granularity | Integer 1-5 (per-input). Decimal only on aggregate average. |
| Submission window | Session must be past (`start_at + duration_minutes < NOW()`) AND user must have an attendance row for that session. |
| Uniqueness | One review per `(coach, student, session)`. Enforced at DB layer. |
| Edit after submit | Never. |
| Delete after submit | Never (not even admin). |
| Anonymous submissions | Not supported. |
| Coach visibility | **Zero.** Coach cannot see aggregate, individual content, count, or even know feedback exists. Admin tells coach manually. |
| Student visibility | Own submitted reviews only (read-only). |
| Admin visibility | Full — list of reviews per coach + aggregate stats. |

---

## Data structures

### Domain model

A `Review` (FE side) maps to one row in the backend `coach_reviews` table.

| FE field | BE field | Type | Required | Notes |
|---|---|---|---|---|
| `id` | `id` | `int` | yes | Server-generated. |
| `coachId` | `coach_id` | `int` | yes | FK → `coaches`. Server derives from `session.coach_id` on submit; client doesn't send. |
| `sessionId` | `session_id` | `int` | yes | FK → `sessions`. Comes from URL path on submit. |
| `reviewerId` (student) | `student_profile_id` | `int` | yes | FK → `student_profiles`. Server derives from `auth()->user()`. |
| `rating` | `rating` | `int` (1-5) | yes | Validated server-side. |
| `comment` | `comment` | `string` (≤500 chars) \| `null` | no | Free-text optional. |
| `createdAt` | `created_at` | `DateTime` (ISO 8601 UTC) | yes | |

**FE model adjustments needed** in `lib/features/review/data/models/review.dart`:

- **Drop `isAnonymous` field** — spec forbids anonymity.
- **Drop `reviewerName` if it's only ever the current user** — server doesn't send it on `my-review` (auth context is implicit). Keep it on admin-list responses where the reviewer is someone else.
- **Drop `coachName`, `sessionTitle`, `sport`** if FE can resolve them from the parent context (session detail screen, coach profile, etc.). Server includes `coach.name` and `session.title` only on the admin list + `me/reviews` endpoints (see response shapes below).

Recommended new shape:

```dart
@freezed
class Review with _$Review {
  const factory Review({
    required int id,
    required int coachId,
    required int sessionId,
    required int rating,
    String? comment,
    required DateTime createdAt,
    // Hydrated only on admin-list / me-list responses:
    String? coachName,
    String? sessionTitle,
    DateTime? sessionDate,
    String? reviewerName,  // null on student's own list (it's themselves)
  }) = _Review;
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
```

### Aggregate model

For admin coach detail screen (`lib/features/coach/presentation/screens/`).

```dart
@freezed
class CoachReviewAggregate with _$CoachReviewAggregate {
  const factory CoachReviewAggregate({
    required double averageRating,        // e.g. 4.3 — always present, 0.0 when empty
    required int count,                   // always present, 0 when empty
    required Map<int, int> distribution,  // {1: 0, 2: 1, 3: 2, 4: 8, 5: 12}
                                          // always all 5 keys present
  }) = _CoachReviewAggregate;
  factory CoachReviewAggregate.fromJson(Map<String, dynamic> json) =>
      _$CoachReviewAggregateFromJson(json);
}
```

---

## Endpoints

All paths are **relative to `AppEnv.apiBaseUrl`** (which already includes `/api`). Repository code uses `/v1/...`.

### 1. POST `/v1/coach/sessions/{sessionId}/reviews` — student submit

**Auth:** authenticated user with `student_profile_id`.

**Request body:**
```json
{
  "rating": 5,
  "comment": "Coachnya sabar dan teknikal."
}
```

**Validation order on server (FE handles each error case):**

| Step | Failure | Response |
|---|---|---|
| 1 | `rating` not integer 1-5 | `422` `{"errors": {"rating": ["..."]}}` |
| 2 | `comment` > 500 chars | `422` `{"errors": {"comment": ["..."]}}` |
| 3 | Session doesn't exist or wrong tenant | `404` |
| 4 | Session not yet ended | `422` `{"message": "Sesi belum selesai. Anda dapat memberi ulasan setelah sesi berakhir."}` |
| 5 | User did not attend the session | `403` `{"message": "Hanya peserta sesi yang dapat memberi ulasan."}` |
| 6 | User already reviewed this session | `409` `{"message": "Anda sudah memberi ulasan untuk sesi ini."}` |

**Success (201):**
```json
{
  "id": 42,
  "coach_id": 7,
  "session_id": 88,
  "rating": 5,
  "comment": "Coachnya sabar dan teknikal.",
  "created_at": "2026-05-05T18:30:00Z"
}
```

(Excludes `student_profile_id` and `tenant_id` — inferable from auth.)

### 2. GET `/v1/coach/sessions/{sessionId}/my-review` — student check own

**Auth:** authenticated user with `student_profile_id`.

**Used by:** the post-session "Beri Ulasan" banner / CTA gating logic. Replaces the current `hasReviewed → bool` mock pattern with a richer "absent or present" return so the FE can also display the existing review without a second round-trip.

**Success (200) — review exists:**
```json
{
  "review": {
    "id": 42,
    "rating": 5,
    "comment": "Coachnya sabar dan teknikal.",
    "created_at": "2026-05-05T18:30:00Z"
  }
}
```

**Success (200) — no review yet:**
```json
{ "review": null }
```

(Note: `null` here means "structurally absent." Treat it as a 200 success with empty payload, NOT as a 404 / error.)

### 3. GET `/v1/me/reviews?per_page=20&cursor=...` — student's own history

**Auth:** authenticated user with `student_profile_id`.

Read-only paginated list of reviews submitted by the current user. Use this for a "My Reviews" screen if/when needed.

**Success (200):**
```json
{
  "data": [
    {
      "id": 42,
      "coach": { "id": 7, "name": "Coach Andi" },
      "session": {
        "id": 88,
        "title": "Tennis Pemula — Sesi 4",
        "date": "2026-05-03"
      },
      "rating": 5,
      "comment": "Coachnya sabar dan teknikal.",
      "created_at": "2026-05-05T18:30:00Z"
    }
  ],
  "next_cursor": null
}
```

Empty: `data: []`, `next_cursor: null`.

### 4. GET `/v1/admin/coaches/{coachId}/reviews?per_page=20&cursor=...` — admin list

**Auth:** admin / super-admin with `view-coaches` permission.

**Coach role MUST NEVER call this endpoint.** Server enforces, but FE should also gate the call site.

**Success (200):**
```json
{
  "data": [
    {
      "id": 12,
      "rating": 5,
      "comment": "Coachnya sabar dan jelas.",
      "created_at": "2026-05-04T18:00:00Z",
      "student": {
        "id": 71,
        "name": "Andi Pratama",
        "photo_url": "https://..."
      },
      "session": {
        "id": 88,
        "title": "Tennis Pemula — Sesi 4",
        "date": "2026-05-03"
      }
    }
  ],
  "next_cursor": null
}
```

Notes:
- `session` is **always present** (every review is tied to a session).
- `comment` may be `null` (optional on submit).
- Empty: `data: []`.

### 5. GET `/v1/admin/coaches/{coachId}/reviews/aggregate` — admin aggregate

**Auth:** admin / super-admin with `view-coaches` permission.

**Coach role MUST NEVER call this endpoint.**

**Success (200), with data:**
```json
{
  "average_rating": 4.3,
  "count": 23,
  "distribution": { "1": 0, "2": 1, "3": 2, "4": 8, "5": 12 }
}
```

**Success (200), no data yet:**
```json
{
  "average_rating": 0.0,
  "count": 0,
  "distribution": { "1": 0, "2": 0, "3": 0, "4": 0, "5": 0 }
}
```

Numeric fields **always present** (per response contract conventions). FE should hide the rating chip when `count == 0` rather than show "0.0 ⭐", which is misleading.

---

## FE implementation checklist

Files to create:

- **`lib/features/review/data/api_review_repository.dart`** — implements existing `ReviewRepository` abstract class. Replaces `MockReviewRepository` for the `apiReviewRepositoryProvider`.

Files to modify:

| File | Change |
|---|---|
| `lib/features/review/data/models/review.dart` | Drop `isAnonymous`. Make `coachName`, `sessionTitle`, `sport` nullable (only present on list responses). Match new JSON shape. Re-run codegen (`build_runner`). |
| `lib/features/review/data/review_repository.dart` | Update `hasReviewed` return type to `Future<Review?>` instead of `bool` (richer return; FE checks `null` for "not reviewed"). Or keep `bool` and call `my-review` internally — choose the simpler one. |
| `lib/features/review/providers/review_providers.dart` | Switch `reviewRepositoryProvider` to return `ApiReviewRepository(apiClient)` (drop `MockReviewRepository`). Match `Task 7C` lockstep pattern. |
| `lib/features/review/presentation/screens/submit_review_screen.dart` | **Privacy notice line ~209**: change from `'Ulasan ini hanya dapat dilihat oleh Anda dan coach.'` to `'Ulasan ini hanya dapat dilihat oleh Anda dan admin. Coach tidak melihat ulasan secara langsung.'` |
| `lib/features/review/presentation/screens/submit_review_screen.dart` | Error handling: catch `DioException` and surface friendly Indonesian messages per status code (see error-mapping table below). |
| `lib/features/review/presentation/widgets/post_session_review_banner.dart` | Gate visibility by all three: session is past, user attended, no existing review. Use `getMyReview` (or `hasReviewed`) for the third check. |
| `lib/features/coach/presentation/screens/coach_dashboard_screen.dart` | Drop "Rating" and "Ulasan Terbaru" widgets (per Issue 2 + Issue 13 — coach has zero review visibility). |
| `lib/features/review/data/mock_review_repository.dart` | Keep file for unit tests, but no longer wired in production. Update mock to match new model shape (drop `isAnonymous`, etc.). |

### Error → message mapping (for `_submit()` in `submit_review_screen.dart`)

```dart
on DioException catch (e) {
  final code = e.response?.statusCode;
  final body = e.response?.data is Map<String, dynamic>
      ? e.response!.data as Map<String, dynamic>
      : null;
  final serverMessage = body?['message'] as String?;

  String message = switch (code) {
    409 => serverMessage ?? 'Anda sudah memberi ulasan untuk sesi ini.',
    403 => serverMessage ?? 'Hanya peserta sesi yang dapat memberi ulasan.',
    422 => serverMessage ?? 'Periksa kembali rating atau komentar Anda.',
    404 => 'Sesi tidak ditemukan.',
    _   => 'Gagal mengirim ulasan. Coba lagi.',
  };
  // show in SnackBar...
}
```

### CTA gating logic (post-session-review-banner)

```dart
// Banner shows only when ALL true:
final isPastSession = sessionEndedAt.isBefore(DateTime.now());
final didAttend = await attendanceRepo.didAttend(sessionId, currentUserId);
final myReview = await reviewRepo.getMyReview(sessionId);
final shouldShowBanner = isPastSession && didAttend && myReview == null;
```

If `myReview != null`, optionally show a small "Ulasan Terkirim" badge with the rating instead of the CTA.

### `ApiReviewRepository` skeleton

```dart
class ApiReviewRepository implements ReviewRepository {
  final ApiClient _api;
  ApiReviewRepository(this._api);

  @override
  Future<Review> submitReview({
    required String coachId,        // ignored — server derives from session
    required String sessionId,
    required int rating,
    String? comment,
  }) async {
    final response = await _api.post(
      '/v1/coach/sessions/$sessionId/reviews',
      data: {
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
    return Review.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Review?> getMyReview(String sessionId) async {
    final response = await _api.get('/v1/coach/sessions/$sessionId/my-review');
    final data = response.data as Map<String, dynamic>;
    final review = data['review'];
    return review == null
        ? null
        : Review.fromJson(review as Map<String, dynamic>);
  }

  @override
  Future<List<Review>> getPlayerReviews(String reviewerId) async {
    // reviewerId ignored — server uses auth context.
    final response = await _api.get('/v1/me/reviews');
    final list = (response.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Review.fromJson).toList();
  }

  // Admin-only — call only when user role is organizer/super-admin
  @override
  Future<List<Review>> getCoachReviews(String coachId) async {
    final response = await _api.get('/v1/admin/coaches/$coachId/reviews');
    final list = (response.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Review.fromJson).toList();
  }

  @override
  Future<CoachRatingAggregate> getCoachRating(String coachId) async {
    final response =
        await _api.get('/v1/admin/coaches/$coachId/reviews/aggregate');
    return CoachRatingAggregate.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // Methods that no longer make sense post-spec:
  @override
  Future<List<Review>> getSessionReviews(String sessionId) =>
      throw UnsupportedError(
        'Session-scoped review listing is not exposed; use admin/me endpoints.',
      );

  @override
  Future<bool> hasReviewed({
    required String reviewerId,
    required String sessionId,
  }) async {
    final review = await getMyReview(sessionId);
    return review != null;
  }
}
```

---

## Permission matrix (FE-side enforcement)

In addition to backend enforcement, FE should not even surface UI that calls forbidden endpoints:

| User role | Can see | Cannot see |
|---|---|---|
| Player (member) | Submit form, own review history (`/me/reviews`), own review per session | Anything about other users' reviews |
| Coach | Nothing review-related at all (no rating chip on dashboard, no review list in own profile, no aggregate) | Everything |
| Organizer (admin) / Super-admin | Admin coach detail with full review list + aggregate | Reviews from other tenants (server scopes) |
| Court owner | Nothing review-related (out of scope) | — |

---

## Testing notes

- Unit-test `ApiReviewRepository` against mocked `Dio` responses (200/201/409/422).
- Widget-test `SubmitReviewScreen` end-to-end submit flow including the 4 error cases.
- `MockReviewRepository` is preserved for unit-test overrides; update its mock data to drop `isAnonymous` etc. so the model stays consistent.

---

## Cross-references

- **Backend spec:** `C:\laragon\www\hypercoach\docs\superpowers\flutter-issue-mapping-2026-05-04.md` Issue 13.
- **FE issue mapping:** `docs/issue-mapping-2026-05-04.md` Issue 13 (this repo).
- **Existing FE files (do NOT delete; modify in place):**
  - `lib/features/review/data/review_repository.dart` (interface)
  - `lib/features/review/data/models/review.dart` (model — needs codegen rerun)
  - `lib/features/review/presentation/screens/submit_review_screen.dart` (UI exists)
  - `lib/features/review/presentation/screens/coach_review_list_screen.dart` (UI exists)
  - `lib/features/review/presentation/widgets/post_session_review_banner.dart` (gating logic)
  - `lib/features/review/providers/review_providers.dart` (Riverpod wiring)
