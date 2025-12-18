# FEATURE-001 — Credit Limit Warning (Basit)

## Amaç

Kullanıcı bir **Satış Siparişi (Sales Order)** üzerinde müşteri seçtiğinde, müşterinin kredi limiti aşılıyorsa kullanıcıya bilgilendirici bir uyarı göstermek.

Bu örnek, eğitimde:

- Basit bir iş kuralı
- Tek noktada kontrol
- Deterministik sonuçlar
  üzerinden unit test yazmayı hedefler.

## Kapsam (Scope)

- **Belge:** Sales Order
- **An:** Müşteri alanı doğrulanınca (ör. Customer No. validate)
- **Davranış:** Kredi limiti aşılıyorsa uyarı mesajı

## Kapsam Dışı (Out of Scope)

- Otomatik bloklama (sipariş kaydetmeyi engelleme)
- Sevkiyat/faturalama akışları
- Kredi limiti hesaplamasında açık siparişlerin/irsaliyelerin dahil edilmesi

## İş Kuralları (Basit Varsayım)

- Müşteri için “kredi limiti” alanı vardır.
- Müşteri için “mevcut bakiye” alanı vardır.
- **Aşım koşulu:** `Balance > Credit Limit`.

## Acceptance Criteria

### AC1 — Aşım yoksa uyarı yok

**Given** müşteri için `Balance <= Credit Limit`
**When** kullanıcı Sales Order’da müşteri seçer
**Then** sistem uyarı mesajı göstermez.

### AC2 — Aşım varsa uyarı göster

**Given** müşteri için `Balance > Credit Limit`
**When** kullanıcı Sales Order’da müşteri seçer
**Then** sistem bir uyarı mesajı gösterir.

### AC3 — Mesaj içeriği kullanıcıya anlamlı olmalı

**Given** kredi limiti aşılmış bir müşteri
**When** kullanıcı müşteri seçer
**Then** mesaj en az şu bilgileri içerir:

- Müşteri No/Ad
- Credit Limit değeri
- Balance değeri

## Test Notları (Unit Test için)

- Test verisi: bir müşteri (limit/bakiye kombinasyonları ile)
- Doğrulama: mesajın gösterilip gösterilmediği ve (opsiyonel) mesaj içeriği
- Basitliği korumak için hesap sadece müşteri kartı alanlarından yapılır

## Test-First mi, Test-After mı? (Eğitim Notu)

Bu örnek **basit ve izole edilebilir** olduğu için öneri: **Test-first (TDD’e yakın)**.

- Yeni geliştirmede: Önce “aşım var/yok” senaryoları için test (kırmızı), sonra minimum kod (yeşil).
- Eğer bu feature zaten yazılmış olsaydı: Önce mevcut davranışı sabitleyen **regression/characterization testleri** yazıp, sonra iyileştirme/refactor yapmak daha güvenlidir.
