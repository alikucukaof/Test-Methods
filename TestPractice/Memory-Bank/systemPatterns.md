# System Patterns

## Repo yapısı (AL-Go)

- TestPractice/: ana uygulama
- TestPractice.Test/: test uygulaması (Library Assert, Any + ana app dependency)

## Test yaklaşımı

- Business-rule mantığı mümkünse “policy” codeunit’lerine ayrılır.
- Testler Given/When/Then isimlendirme + AAA adımlarıyla yazılır.
- UI/aksiyon entegrasyonu gerekiyorsa önce policy testlenir, sonra subscriber/entegrasyon testleri eklenir.
