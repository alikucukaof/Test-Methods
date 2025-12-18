# TASK001 - Credit Limit eğitim örnekleri ve test iskeletleri

**Status:** Completed  
**Added:** 2025-12-18  
**Updated:** 2025-12-18

## Original Request

- İki örnek feature + acceptance criteria (basit/orta)
- Bu iki feature’a uygun test case listesi (Given/When/Then → AAA)
- TestPractice.Test projesi için iskelet test codeunit’leri

## Thought Process

- Eğitimde testleri deterministik tutmak için “policy” codeunit yaklaşımı seçildi.
- Standard BC setup bağımlılıklarını azaltmak için hesaplama, mesaj üretimi ve release kontrolü parametre bazlı tasarlandı.
- MessageHandler ve `asserterror` desenleri örneklendi.

## Implementation Plan

- Feature dokümanlarını ekle
- Test case listesini AAA formatında yaz
- App’e unit-testable policy codeunit ekle
- Test projesine 2 iskelet test codeunit ekle
- Lint/diagnostic hataları düzelt

## Progress Tracking

**Overall Status:** Completed - 100%

### Subtasks

| ID  | Description                | Status   | Updated    | Notes                          |
| --- | -------------------------- | -------- | ---------- | ------------------------------ |
| 1.1 | Feature dokümanlarını ekle | Complete | 2025-12-18 | Basit + orta seviye            |
| 1.2 | Test case listesini yaz    | Complete | 2025-12-18 | AAA mapping ile                |
| 1.3 | Policy codeunit ekle       | Complete | 2025-12-18 | Parametre bazlı, deterministik |
| 1.4 | Test codeunit’leri ekle    | Complete | 2025-12-18 | MessageHandler + asserterror   |
| 1.5 | Lint hatalarını düzelt     | Complete | 2025-12-18 | Label comment + PermissionSet  |

## Progress Log

### 2025-12-18

- `src/Credit Limit/` altına 2 feature dokümanı eklendi.
- `TestCases-CreditLimit.md` ile Given/When/Then → AAA dönüşümü yazıldı.
- App’e `Credit Limit Policy` codeunit’i eklendi.
- Test projesine uyarı ve release engelleme için 2 test codeunit’i eklendi.
- Lint/diagnostic hataları: placeholder comment + permission set caption/lock düzeltildi.
