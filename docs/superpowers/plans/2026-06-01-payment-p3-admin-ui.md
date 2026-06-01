# Payment P3 — Web Admin UI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Vue 3 admin page where organizer admin can toggle Manual/VA/QRIS-disabled/eWallet-disabled methods + edit per-VA-bank subset + manage manual bank details.

**Architecture:** Single Vue SFC `AdminPaymentSettings.vue` consuming the P2 REST endpoints via a Pinia store + axios service. Reuses existing admin layout + PrimeVue Unstyled + Tailwind preset. No new BE work (depends on P2).

**Tech Stack:** Vue 3 Composition API + `<script setup>`, Pinia, axios (existing instance), PrimeVue Unstyled + Tailwind, Vue Router (existing).

**Repo:** `C:\laragon\www\hypercoach`. Vue SPA at `resources/js/`.

---

## File Structure

| File | Responsibility |
|---|---|
| `resources/js/services/paymentSettingsApi.js` | Wrapper around the 2 admin endpoints |
| `resources/js/stores/paymentSettings.js` | Pinia store: load/save state, error/loading flags |
| `resources/js/pages/admin/AdminPaymentSettings.vue` | The page (4 toggle cards + bank details form + save bar) |
| `resources/js/components/payment/MethodToggleCard.vue` | Reusable single-method card (title + switch + collapsible body) |
| `resources/js/components/payment/ManualBankDetailsForm.vue` | Bank name + acc number + acc holder + instructions textarea |
| `resources/js/components/payment/VaBanksMultiSelect.vue` | Checkbox group of 4 supported banks |
| `resources/js/router/index.js` | Add `/admin/settings/payment-methods` route (modify existing) |
| `resources/js/layouts/AdminLayout.vue` or sidebar nav | Add sidebar menu link (modify existing) |
| `resources/js/locales/{en,id,ms}.json` | i18n strings for "Metode Pembayaran" + descriptions (modify existing) |

---

## Task 1: API service wrapper

**Files:**
- Create: `resources/js/services/paymentSettingsApi.js`

- [ ] **Step 1: Create wrapper**

```javascript
// resources/js/services/paymentSettingsApi.js
import api from './api'; // existing axios instance

/**
 * Wrapper for /api/v1/admin/tenant/payment-settings endpoints.
 * All methods return the response body directly (or throw on HTTP error).
 */
export const paymentSettingsApi = {
    async get() {
        const response = await api.get('/admin/tenant/payment-settings');
        return response.data;
    },

    async update(payload) {
        const response = await api.patch('/admin/tenant/payment-settings', payload);
        return response.data;
    },
};
```

- [ ] **Step 2: Commit**

```bash
cd /c/laragon/www/hypercoach
git add resources/js/services/paymentSettingsApi.js
git commit -m "Payment P3: paymentSettingsApi service wrapper"
```

---

## Task 2: Pinia store

**Files:**
- Create: `resources/js/stores/paymentSettings.js`

- [ ] **Step 1: Create store**

```javascript
// resources/js/stores/paymentSettings.js
import { defineStore } from 'pinia';
import { paymentSettingsApi } from '@/services/paymentSettingsApi';

export const usePaymentSettingsStore = defineStore('paymentSettings', {
    state: () => ({
        settings: {
            manual_enabled: true,
            va_enabled: false,
            qris_enabled: false,
            ewallet_enabled: false,
            va_banks: [],
        },
        platformXenditConfigured: false,
        loading: false,
        saving: false,
        error: null,
    }),

    actions: {
        async fetch() {
            this.loading = true;
            this.error = null;
            try {
                const data = await paymentSettingsApi.get();
                this.settings = { ...this.settings, ...data.settings };
                this.platformXenditConfigured = data.platform_xendit_configured;
            } catch (e) {
                this.error = e.response?.data?.message || 'Gagal memuat pengaturan.';
                throw e;
            } finally {
                this.loading = false;
            }
        },

        async save() {
            this.saving = true;
            this.error = null;
            try {
                const data = await paymentSettingsApi.update(this.settings);
                this.settings = { ...this.settings, ...data.settings };
                return data;
            } catch (e) {
                this.error = e.response?.data?.message
                    || 'Gagal menyimpan. Periksa form.';
                throw e;
            } finally {
                this.saving = false;
            }
        },
    },
});
```

- [ ] **Step 2: Commit**

```bash
git add resources/js/stores/paymentSettings.js
git commit -m "Payment P3: paymentSettings Pinia store"
```

---

## Task 3: `MethodToggleCard` reusable component

**Files:**
- Create: `resources/js/components/payment/MethodToggleCard.vue`

- [ ] **Step 1: Create component**

```vue
<!-- resources/js/components/payment/MethodToggleCard.vue -->
<script setup>
import { computed } from 'vue';

const props = defineProps({
    title: { type: String, required: true },
    description: { type: String, default: '' },
    enabled: { type: Boolean, required: true },
    disabled: { type: Boolean, default: false },
    disabledHint: { type: String, default: '' },
    icon: { type: String, default: '' },
});

const emit = defineEmits(['update:enabled']);

const toggle = (value) => {
    if (props.disabled) return;
    emit('update:enabled', value);
};

const wrapperClass = computed(() => [
    'border rounded-lg p-4 transition',
    props.enabled && !props.disabled ? 'border-teal-500 bg-teal-50' : 'border-slate-200 bg-white',
    props.disabled ? 'opacity-60' : '',
]);
</script>

<template>
    <div :class="wrapperClass">
        <div class="flex items-start justify-between gap-4">
            <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2 mb-1">
                    <span v-if="icon" class="text-xl">{{ icon }}</span>
                    <h3 class="font-bold text-slate-900">{{ title }}</h3>
                </div>
                <p v-if="description" class="text-sm text-slate-600">
                    {{ description }}
                </p>
                <p v-if="disabled && disabledHint" class="text-xs text-amber-700 mt-1">
                    {{ disabledHint }}
                </p>
            </div>
            <label class="relative inline-flex items-center cursor-pointer flex-shrink-0">
                <input
                    type="checkbox"
                    :checked="enabled"
                    :disabled="disabled"
                    class="sr-only peer"
                    @change="toggle($event.target.checked)"
                />
                <div class="w-11 h-6 bg-slate-200 rounded-full peer-checked:bg-teal-600 peer-disabled:opacity-50 peer-focus:ring-2 peer-focus:ring-teal-300 transition">
                    <div class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full transition peer-checked:translate-x-5"></div>
                </div>
            </label>
        </div>
        <div v-if="enabled && !disabled" class="mt-4 pt-4 border-t border-slate-200">
            <slot />
        </div>
    </div>
</template>
```

- [ ] **Step 2: Commit**

```bash
git add resources/js/components/payment/MethodToggleCard.vue
git commit -m "Payment P3: MethodToggleCard component (toggle + collapsible body)"
```

---

## Task 4: `ManualBankDetailsForm` component

**Files:**
- Create: `resources/js/components/payment/ManualBankDetailsForm.vue`

- [ ] **Step 1: Create component**

```vue
<!-- resources/js/components/payment/ManualBankDetailsForm.vue -->
<script setup>
const props = defineProps({
    modelValue: {
        type: Object,
        required: true,
        // { bank_name, account_number, account_holder, payment_instructions }
    },
});
defineEmits(['update:modelValue']);

const update = (key, value) => {
    emit('update:modelValue', { ...props.modelValue, [key]: value });
};
</script>

<template>
    <div class="space-y-3">
        <div>
            <label class="block text-sm font-medium text-slate-700 mb-1">
                Nama Bank
            </label>
            <input
                type="text"
                :value="modelValue.bank_name"
                @input="update('bank_name', $event.target.value)"
                placeholder="contoh: BCA, Mandiri"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:ring-2 focus:ring-teal-500 focus:border-teal-500"
            />
        </div>
        <div>
            <label class="block text-sm font-medium text-slate-700 mb-1">
                Nomor Rekening
            </label>
            <input
                type="text"
                :value="modelValue.account_number"
                @input="update('account_number', $event.target.value)"
                placeholder="contoh: 1234567890"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:ring-2 focus:ring-teal-500 focus:border-teal-500"
            />
        </div>
        <div>
            <label class="block text-sm font-medium text-slate-700 mb-1">
                Atas Nama
            </label>
            <input
                type="text"
                :value="modelValue.account_holder"
                @input="update('account_holder', $event.target.value)"
                placeholder="contoh: PT Petenis Kelana"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:ring-2 focus:ring-teal-500 focus:border-teal-500"
            />
        </div>
        <div>
            <label class="block text-sm font-medium text-slate-700 mb-1">
                Instruksi Tambahan (opsional)
            </label>
            <textarea
                :value="modelValue.payment_instructions"
                @input="update('payment_instructions', $event.target.value)"
                rows="2"
                placeholder="contoh: Mohon transfer tepat sesuai nominal, lalu upload bukti"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:ring-2 focus:ring-teal-500 focus:border-teal-500"
            />
        </div>
    </div>
</template>
```

Note: Bank details live on the `Tenant` model (`payment_bank_name`, etc.), not on `tenant_payment_settings`. This form binds to `tenantStore.tenant` values or fetches via the existing tenant profile endpoint. **For P3 we read the values but defer the save to either an existing tenant settings endpoint or extend it.** If no endpoint exists yet, this task only renders read-only display + leaves a TODO comment. **Verify which tenant settings endpoint exists before completing.**

- [ ] **Step 2: Commit**

```bash
git add resources/js/components/payment/ManualBankDetailsForm.vue
git commit -m "Payment P3: ManualBankDetailsForm component (4 fields)"
```

---

## Task 5: `VaBanksMultiSelect` component

**Files:**
- Create: `resources/js/components/payment/VaBanksMultiSelect.vue`

- [ ] **Step 1: Create component**

```vue
<!-- resources/js/components/payment/VaBanksMultiSelect.vue -->
<script setup>
const SUPPORTED_BANKS = [
    { code: 'BCA', label: 'BCA' },
    { code: 'MANDIRI', label: 'Mandiri' },
    { code: 'BRI', label: 'BRI' },
    { code: 'BNI', label: 'BNI' },
];

const props = defineProps({
    modelValue: { type: Array, required: true },
});
const emit = defineEmits(['update:modelValue']);

const toggle = (code, checked) => {
    const next = checked
        ? [...new Set([...props.modelValue, code])]
        : props.modelValue.filter(b => b !== code);
    emit('update:modelValue', next);
};
</script>

<template>
    <div>
        <p class="text-sm text-slate-600 mb-2">
            Bank yang diterima (minimal 1)
        </p>
        <div class="grid grid-cols-2 gap-2">
            <label
                v-for="bank in SUPPORTED_BANKS"
                :key="bank.code"
                class="flex items-center gap-2 p-2 border rounded cursor-pointer hover:bg-slate-50"
                :class="modelValue.includes(bank.code) ? 'border-teal-500 bg-teal-50' : 'border-slate-200'"
            >
                <input
                    type="checkbox"
                    :checked="modelValue.includes(bank.code)"
                    @change="toggle(bank.code, $event.target.checked)"
                    class="w-4 h-4 text-teal-600 rounded focus:ring-teal-500"
                />
                <span class="text-sm font-medium text-slate-900">{{ bank.label }}</span>
            </label>
        </div>
    </div>
</template>
```

- [ ] **Step 2: Commit**

```bash
git add resources/js/components/payment/VaBanksMultiSelect.vue
git commit -m "Payment P3: VaBanksMultiSelect component (4 banks)"
```

---

## Task 6: `AdminPaymentSettings.vue` page

**Files:**
- Create: `resources/js/pages/admin/AdminPaymentSettings.vue`

- [ ] **Step 1: Create page**

```vue
<!-- resources/js/pages/admin/AdminPaymentSettings.vue -->
<script setup>
import { onMounted, computed } from 'vue';
import { usePaymentSettingsStore } from '@/stores/paymentSettings';
import MethodToggleCard from '@/components/payment/MethodToggleCard.vue';
import VaBanksMultiSelect from '@/components/payment/VaBanksMultiSelect.vue';

const store = usePaymentSettingsStore();

onMounted(() => {
    store.fetch();
});

const hasChanges = computed(() => {
    // For MVP, allow save anytime; could compare against snapshot in V2
    return true;
});

const save = async () => {
    try {
        await store.save();
        // Toast — assume there's a global toast service; otherwise console.log
        window.dispatchEvent(new CustomEvent('toast', {
            detail: { type: 'success', message: 'Perubahan tersimpan.' }
        }));
    } catch (e) {
        // Error message already in store.error
    }
};
</script>

<template>
    <div class="max-w-3xl mx-auto p-6 pb-32">
        <header class="mb-6">
            <h1 class="text-2xl font-bold text-slate-900">Metode Pembayaran</h1>
            <p class="text-sm text-slate-600 mt-1">
                Atur metode pembayaran yang bisa dipilih anggota saat memesan sesi.
            </p>
        </header>

        <div v-if="store.loading" class="text-center py-12 text-slate-500">
            Memuat pengaturan...
        </div>

        <div v-else-if="store.error" class="bg-red-50 border border-red-200 text-red-800 p-4 rounded mb-4">
            {{ store.error }}
        </div>

        <div v-else class="space-y-4">
            <!-- Manual Transfer -->
            <MethodToggleCard
                title="Transfer Manual"
                description="Anggota transfer ke rekening klub, lalu upload bukti pembayaran. Admin verifikasi manual."
                icon="🏦"
                :enabled="store.settings.manual_enabled"
                @update:enabled="store.settings.manual_enabled = $event"
            >
                <p class="text-sm text-slate-600">
                    Detail rekening bank diatur di
                    <a href="/admin/settings/tenant" class="text-teal-600 underline">Profil Klub</a>.
                </p>
            </MethodToggleCard>

            <!-- Virtual Account -->
            <MethodToggleCard
                title="Virtual Account otomatis"
                description="Anggota bayar via VA bank, verifikasi otomatis. Biaya admin ditanggung anggota."
                icon="💳"
                :enabled="store.settings.va_enabled"
                :disabled="!store.platformXenditConfigured"
                disabled-hint="Belum tersedia — hubungi admin platform untuk aktifkan."
                @update:enabled="store.settings.va_enabled = $event"
            >
                <VaBanksMultiSelect v-model="store.settings.va_banks" />
            </MethodToggleCard>

            <!-- QRIS (P5 future) -->
            <MethodToggleCard
                title="QRIS otomatis"
                description="Scan QR untuk bayar via OVO / GoPay / DANA / dll."
                icon="📱"
                :enabled="false"
                :disabled="true"
                disabled-hint="Akan datang"
            />

            <!-- E-Wallet (P5 future) -->
            <MethodToggleCard
                title="E-Wallet otomatis"
                description="OVO, GoPay, DANA, ShopeePay."
                icon="👛"
                :enabled="false"
                :disabled="true"
                disabled-hint="Akan datang"
            />
        </div>

        <!-- Sticky save bar -->
        <div
            v-if="!store.loading && hasChanges"
            class="fixed bottom-0 left-0 right-0 bg-white border-t border-slate-200 p-4 shadow-lg"
        >
            <div class="max-w-3xl mx-auto flex justify-end gap-3">
                <button
                    type="button"
                    class="px-4 py-2 text-slate-700 hover:bg-slate-100 rounded"
                    :disabled="store.saving"
                    @click="store.fetch()"
                >
                    Batalkan
                </button>
                <button
                    type="button"
                    class="px-6 py-2 bg-teal-600 text-white font-bold rounded hover:bg-teal-700 disabled:opacity-50"
                    :disabled="store.saving"
                    @click="save"
                >
                    {{ store.saving ? 'Menyimpan...' : 'Simpan Perubahan' }}
                </button>
            </div>
        </div>
    </div>
</template>
```

- [ ] **Step 2: Commit**

```bash
git add resources/js/pages/admin/AdminPaymentSettings.vue
git commit -m "Payment P3: AdminPaymentSettings.vue page (4 toggle cards + save bar)"
```

---

## Task 7: Wire route + nav link

**Files:**
- Modify: `resources/js/router/index.js`
- Modify: existing admin sidebar nav file (likely `AdminLayout.vue` or `AdminSidebar.vue`)

- [ ] **Step 1: Add route**

Find the admin routes section in `resources/js/router/index.js` and add:
```javascript
{
    path: '/admin/settings/payment-methods',
    name: 'admin.settings.payment-methods',
    component: () => import('@/pages/admin/AdminPaymentSettings.vue'),
    meta: {
        layout: 'admin',
        title: 'Metode Pembayaran',
        permission: 'manage-tenant-settings',
    },
},
```

- [ ] **Step 2: Add sidebar nav link**

Find the admin sidebar component (likely `resources/js/layouts/AdminLayout.vue` or `resources/js/components/AdminSidebar.vue`). Locate the "Settings" or "Pengaturan" section and add an item:
```vue
<router-link
    to="/admin/settings/payment-methods"
    class="sidebar-link"
    v-if="hasPermission('manage-tenant-settings')"
>
    <i class="icon-credit-card"></i>
    Metode Pembayaran
</router-link>
```

(Exact markup depends on existing sidebar pattern — match it.)

- [ ] **Step 3: Commit**

```bash
git add resources/js/router/index.js resources/js/layouts/AdminLayout.vue
# adjust paths to whatever was modified
git commit -m "Payment P3: route + sidebar nav for /admin/settings/payment-methods"
```

---

## Task 8: Build + deploy + smoke test

**Files:** none (verification)

- [ ] **Step 1: Local build verify**

```bash
cd /c/laragon/www/hypercoach
npm run dev
# Open http://hypercoach.local/admin/settings/payment-methods in browser
# Verify: page renders, toggle cards present, save bar at bottom
```

- [ ] **Step 2: Deploy to dev**

```bash
git push origin develop
ssh ak_rocks@103.157.97.233 "/srv/www/hypercoach_dev/scripts/deploy_dev.sh develop"
```

- [ ] **Step 3: Manual smoke test on dev**

Open `https://petenis-kelana.devapp.hyperscore.cloud/admin/settings/payment-methods` as admin user (with `manage-tenant-settings` permission):

- ☐ Page loads, shows 4 toggle cards
- ☐ Manual toggle on, VA toggle off (default)
- ☐ VA toggle disabled (because XENDIT_API_KEY not in env yet — P4a adds it)
- ☐ Tooltip on VA: "Belum tersedia — hubungi admin platform"
- ☐ QRIS + eWallet cards greyed with "Akan datang"
- ☐ Toggle manual off → save → re-fetch shows manual_enabled=false
- ☐ Mobile call `GET payment-methods` for this tenant now returns empty methods (proof BE+FE integration)
- ☐ No "Xendit" text anywhere in UI

- [ ] **Step 4: Final P3 commit (if lint changes)**

```bash
git status
git log --oneline -10
```

---

## P3 Self-Verification Checklist

- [ ] All Vue components render without console errors
- [ ] Pinia store fetches + saves correctly
- [ ] Save shows success toast, errors show in-place
- [ ] Permission gate works (non-admin user sees route or 403)
- [ ] Sidebar link only visible with permission
- [ ] **No "Xendit" string in any user-visible text** (grep `resources/js/` after changes)
- [ ] Mobile `GET payment-methods` API returns correct results after admin toggle

---

## P3 Spec Coverage

- §6.2 Admin write path (via Vue UI)
- §10.1 Admin settings page (4 toggle cards exactly as specified)
- §3 Branding (verified: no "Xendit" in UI strings, descriptions say "otomatis" / "via VA bank")

Deferred: tenant bank details form save (depends on existing tenant settings endpoint — verify what's already there before adding).

Once P3 is verified green, proceed to P4a per the index.
