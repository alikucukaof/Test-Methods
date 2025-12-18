# FEATURE-002 — Credit Limit Block with Approval (Orta)

## Amaç

Kredi limiti aşımı olduğunda, satış belgesinin serbest bırakılması (Release) ve/veya gönderim/faturalama gibi kritik adımların **kontrollü şekilde engellenmesi** ve bunun yönetilebilir bir onay akışıyla aşılabilmesi.

Bu örnek, eğitimde:

- Daha fazla kural ve durum
- Hata (Error) ile işlem durdurma
- Onay verildiğinde davranışın değişmesi
- Unit testlerde hem “pozitif” hem “negatif” senaryolar
  konularını çalıştırmak için tasarlanmıştır.

## Terimler

- **Aşım (Over Limit):** `Balance + DocumentAmount > Credit Limit`
- **Onay (Approval):** “Kredi Aşım Onayı” verilmiş olması

## Kapsam (Scope)

- **Belge:** Sales Order (en azından)
- **Kontrol noktası:** Belgeyi Release etme aksiyonu (Sales Order → Release)
- **Davranış:** Aşım varsa ve onay yoksa işlem hata ile durur

## Kapsam Dışı (Out of Scope)

- Gerçek Approval Workflow entegrasyonu (BC standart Approval Entries kullanımı) — eğitimde “basit onay flag’i” ile simüle edilebilir
- Kredi limiti hesaplamasında çoklu para birimi, kur çevrimi
- Detaylı kullanıcı yetkilendirme modeli

## İş Kuralları

1. Sistem “Aşım” durumunu şu formülle hesaplar:
   - `Balance + DocumentAmount > Credit Limit`
2. Aşım varsa:
   - Onay yoksa Release işlemi engellenir ve hata verilir.
   - Onay varsa Release işlemine izin verilir.
3. Aşım yoksa:
   - Normal davranış sürer.

## Acceptance Criteria

### AC1 — Aşım yoksa Release serbest

**Given** `Balance + DocumentAmount <= Credit Limit`
**When** kullanıcı Sales Order’ı Release eder
**Then** Release başarılı olur.

### AC2 — Aşım varsa ve onay yoksa Release engellenir

**Given** `Balance + DocumentAmount > Credit Limit`
**And** kredi aşım onayı yok
**When** kullanıcı Sales Order’ı Release eder
**Then** sistem hata vererek işlemi durdurur.

### AC3 — Aşım varsa ve onay varsa Release serbest

**Given** `Balance + DocumentAmount > Credit Limit`
**And** kredi aşım onayı var
**When** kullanıcı Sales Order’ı Release eder
**Then** Release başarılı olur.

### AC4 — Hata mesajı eyleme yönlendirmeli

**Given** aşım var ve onay yok
**When** kullanıcı Release dener
**Then** hata mesajı en az şunları belirtir:

- Kredi limiti aşıldı
- Onay gerektiği
- (Opsiyonel) DocumentAmount / Balance / CreditLimit değerleri

## Test Notları (Unit Test için)

- Test verisi: müşteri (Credit Limit), müşteri bakiyesi (Balance), sipariş tutarı (DocumentAmount)
- Test 1: Aşım yok → Release ok
- Test 2: Aşım var + onay yok → Release hata
- Test 3: Aşım var + onay var → Release ok
- Testlerde onay mekanizması basit bir boolean alan veya yardımcı tablo ile simüle edilebilir

## Eğitimde Tartışma Konuları

- Unit testte “Error expected” desenleri
- Hata mesajı doğrulama (metin / label kullanımı)
- Hesaplamayı izole etmek için hesap fonksiyonunu ayrı codeunit’e alma
- Event subscriber ile standard davranışı genişletme (page/action yerine business layer)

## Test-First mi, Test-After mı? (Eğitim Notu)

Bu örnek daha “iş akışı + durum + hata” içerdiği için öneri yaklaşım:

- Yeni geliştirmede: **Hybrid** — önce _çekirdek hesap/karar fonksiyonları_ için **test-first**, ardından Release akışını bağlayan minimal kod; hemen arkasından akış testleri.
- Eğer feature hali hazırda yazılmışsa: Önce “şu an ne yapıyor?”u kilitleyen **characterization testleri** (özellikle `asserterror` ile engelleme senaryosu) yazın; sonra davranışı iyileştirin.

Pratik kural: BC’de UI/aksiyon entegrasyonları bazen keşif gerektirir; ama **business rule** kısmı neredeyse her zaman test-first’e uygundur.
