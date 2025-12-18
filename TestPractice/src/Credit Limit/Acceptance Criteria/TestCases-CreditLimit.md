# Credit Limit — Test Case Listesi (Given/When/Then → AAA)

Bu doküman eğitim içindir: acceptance criteria’leri **Given/When/Then** formatından **Arrange/Act/Assert** (AAA) test adımlarına çevirir.

> Not: Bu repo’da eğitim amacıyla iş kuralları “unit-testable” hale getirilerek bir policy codeunit’i üzerinden testlenebilir. UI/Release entegrasyonu sonraki adım olarak ele alınabilir.

---

## FEATURE-001 — Credit Limit Warning (Basit)

Kaynak: `FEATURE-001-CreditLimitWarning-Simple.md`

### TC-001 — Aşım yoksa uyarı yok (AC1)

**Given** `Balance <= CreditLimit`
**When** “warning kontrolü” çalışır
**Then** mesaj gösterilmez

**Arrange**

- `CustomerNo := 'C0001'`, `CustomerName := 'Test Customer'`
- `CreditLimit := 1000`, `Balance := 1000`
- Message handler ile “mesaj gösterildi mi?” yakalanır

**Act**

- Policy method çağrılır (ör. `ShowOverLimitWarning(CustomerNo, CustomerName, Balance, CreditLimit)`)

**Assert**

- Mesaj gösterilmedi (`MessageDisplayed = false`)

---

### TC-002 — Aşım varsa uyarı göster (AC2)

**Given** `Balance > CreditLimit`
**When** “warning kontrolü” çalışır
**Then** mesaj gösterilir

**Arrange**

- `CreditLimit := 1000`, `Balance := 1000.01`
- Message handler aktif

**Act**

- `ShowOverLimitWarning(...)`

**Assert**

- Mesaj gösterildi (`MessageDisplayed = true`)

---

### TC-003 — Mesaj içeriği anlamlı (AC3)

**Given** aşım var
**When** mesaj üretilir
**Then** mesaj en az CustomerNo/Name ve “Credit Limit / Balance” bilgisini içerir

**Arrange**

- `CustomerNo := 'C0001'`, `CustomerName := 'Test Customer'`
- `CreditLimit := 1000`, `Balance := 1500`

**Act**

- `ShowOverLimitWarning(...)` veya `GetOverLimitWarning(...)`

**Assert**

- Mesaj içinde `CustomerNo` geçer
- Mesaj içinde `CustomerName` geçer
- Mesaj içinde `Credit Limit` ve `Balance` anahtar kelimeleri geçer

---

## FEATURE-002 — Credit Limit Block with Approval (Orta)

Kaynak: `FEATURE-002-CreditLimitBlockWithApproval-Medium.md`

### TC-101 — Aşım yoksa Release serbest (AC1)

**Given** `Balance + DocumentAmount <= CreditLimit`
**When** “release kontrolü” çalışır
**Then** hata vermez

**Arrange**

- `CreditLimit := 1000`, `Balance := 900`, `DocumentAmount := 100`
- `IsApproved := false` (önemsiz)

**Act**

- `EnsureReleaseAllowed(Balance, CreditLimit, DocumentAmount, IsApproved)`

**Assert**

- Hata yok (test başarılı biter)

---

### TC-102 — Aşım var, onay yoksa Release engellenir (AC2)

**Given** `Balance + DocumentAmount > CreditLimit`
**And** `IsApproved = false`
**When** release kontrolü çalışır
**Then** hata verir

**Arrange**

- `CreditLimit := 1000`, `Balance := 900`, `DocumentAmount := 200`
- `IsApproved := false`

**Act**

- `asserterror EnsureReleaseAllowed(...)`

**Assert**

- `GetLastErrorText()` beklenen hata mesajını içerir (örn. “Approval is required”)

---

### TC-103 — Aşım var, onay varsa Release serbest (AC3)

**Given** `Balance + DocumentAmount > CreditLimit`
**And** `IsApproved = true`
**When** release kontrolü çalışır
**Then** hata vermez

**Arrange**

- `CreditLimit := 1000`, `Balance := 900`, `DocumentAmount := 200`
- `IsApproved := true`

**Act**

- `EnsureReleaseAllowed(...)`

**Assert**

- Hata yok

---

### TC-104 — Hata mesajı yönlendirici (AC4)

**Given** aşım var ve onay yok
**When** kontrol çalışır
**Then** hata mesajı “kredi limiti aşıldı” + “onay gerekir” bilgisini içerir

**Arrange**

- TC-102 verisi

**Act**

- `asserterror EnsureReleaseAllowed(...)`

**Assert**

- `GetLastErrorText()` içinde `Credit limit exceeded` ve `Approval` gibi anahtar kelimeler vardır
