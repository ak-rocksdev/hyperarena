import 'package:flutter/material.dart';

/// Sport, booking status, level tier, and rating color tokens.
/// Reference: DESIGN_SYSTEM.md Sections 1.7–1.10
abstract final class AppDomainColors {
  // ── Sport Colors ────────────────────────────────────────────
  static const tennis = Color(0xFF65A30D);
  static const tennisBg = Color(0xFFF5FAD1);
  static const tennisText = Color(0xFF3F6212);

  static const padel = Color(0xFF7C3AED);
  static const padelBg = Color(0xFFEDE9FE);
  static const padelText = Color(0xFF5B21B6);

  static const badminton = Color(0xFF0EA5E9);
  static const badmintonBg = Color(0xFFE0F2FE);
  static const badmintonText = Color(0xFF0369A1);

  static const futsal = Color(0xFFEF4444);
  static const futsalBg = Color(0xFFFEE2E2);
  static const futsalText = Color(0xFFB91C1C);

  static const basketball = Color(0xFFF97316);
  static const basketballBg = Color(0xFFFFF7ED);
  static const basketballText = Color(0xFFC2410C);

  static const volleyball = Color(0xFFEC4899);
  static const volleyballBg = Color(0xFFFCE7F3);
  static const volleyballText = Color(0xFFBE185D);

  static const tableTennis = Color(0xFF14B8A6);
  static const tableTennisBg = Color(0xFFF0FDFA);
  static const tableTennisText = Color(0xFF0F766E);

  // ── Booking Status Colors ───────────────────────────────────
  static const statusPendingPayment = Color(0xFFF59E0B);
  static const statusPendingPaymentBg = Color(0xFFFEF3C7);
  static const statusPendingPaymentText = Color(0xFFD97706);

  static const statusWaitingConfirmation = Color(0xFFF97316);
  static const statusWaitingConfirmationBg = Color(0xFFFFF7ED);
  static const statusWaitingConfirmationText = Color(0xFFC2410C);

  static const statusConfirmed = Color(0xFF22C55E);
  static const statusConfirmedBg = Color(0xFFDCFCE7);
  static const statusConfirmedText = Color(0xFF16A34A);

  static const statusRejected = Color(0xFFEF4444);
  static const statusRejectedBg = Color(0xFFFEE2E2);
  static const statusRejectedText = Color(0xFFDC2626);

  static const statusCancelled = Color(0xFF94A3B8);
  static const statusCancelledBg = Color(0xFFF1F5F9);
  static const statusCancelledText = Color(0xFF475569);

  static const statusCompleted = Color(0xFF3B82F6);
  static const statusCompletedBg = Color(0xFFDBEAFE);
  static const statusCompletedText = Color(0xFF2563EB);

  static const statusExpired = Color(0xFF64748B);
  static const statusExpiredBg = Color(0xFFF1F5F9);
  static const statusExpiredText = Color(0xFF334155);

  // ── Level Tier Colors ───────────────────────────────────────
  static const tierRookie = Color(0xFFCD7F32);
  static const tierRookieBg = Color(0xFFFDF2E3);
  static const tierRookieText = Color(0xFF8B5E20);

  static const tierAmateur = Color(0xFF94A3B8);
  static const tierAmateurBg = Color(0xFFF1F5F9);
  static const tierAmateurText = Color(0xFF64748B);

  static const tierIntermediate = Color(0xFFF59E0B);
  static const tierIntermediateBg = Color(0xFFFEF3C7);
  static const tierIntermediateText = Color(0xFFB45309);

  static const tierAdvanced = Color(0xFF38BDF8);
  static const tierAdvancedBg = Color(0xFFE0F2FE);
  static const tierAdvancedText = Color(0xFF0369A1);

  static const tierPro = Color(0xFFA78BFA);
  static const tierProBg = Color(0xFFEDE9FE);
  static const tierProText = Color(0xFF6D28D9);

  // ── Rating ──────────────────────────────────────────────────
  static const ratingStar = Color(0xFFFFC107);
  static const ratingStarHalf = Color(0xFFFFD54F);
  static const ratingStarEmpty = Color(0xFFE2E8F0);
}
