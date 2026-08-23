# Sprint 3 — addressId Resolution Report

## 1. الهدف

تحويل إنشاء الطلب من إرسال `location` مباشرة إلى إرسال `addressId` عند اختيار عنوان محفوظ. الـ Backend يحلّ العنوان إلى `GeoPoint` ويخزّن `ServiceRequest.location` فقط. **`addressId` لا يُخزَّن** على الـ aggregate ولا يظهر في `RequestResponse`.

## 2. نقطة البداية (Sprint 1+2)

تم التحقق من `main` على GitHub:

| المستودع | Commit | الحالة |
|---|---|---|
| `otlob-platform` | `bf7b762` | location على POST + Address CRUD |
| `otlob-customer-app` | `0e51930` | عناوين حية + إرسال `location` عند الإنشاء |

قبل Sprint 3:

- Backend يرفض `addressId` كحقل غير مدعوم (`UNSUPPORTED_CREATE_FIELDS`)
- Flutter يرسل `location: { latitude, longitude }` عند اختيار عنوان

## 3. نطاق Sprint 3

**ضمن النطاق:**

- DTO + use case + HTTP + DI + `docs/API.md`
- اختبارات unit و HTTP
- Flutter `buildCreateRequestBody` + اختبارات

**خارج النطاق:** Auth، Firestore، Sprint 4، تخزين `addressId` على الطلب.

## 4. تعديلات Backend

### 4.1 DTO — `request_request.ts`

- `addressId?: string | null` حقل مدعوم
- `location` يبقى للتوافق العكسي
- استبعاد متبادل: لا `addressId` + `location` معًا

### 4.2 Use case — `create_request_use_case.ts`

```text
CreateRequestUseCase(requestRepository, addressRepository)
```

قواعد الحل:

1. `addressId` + `location` → `validation_failed` (mutually_exclusive)
2. `addressId` → `findById`؛ Active + `userId === customerId` وإلا `not_found`
3. عنوان بلا إحداثيات → `validation_failed` / `location_required`
4. نسخ `address.location` إلى `ServiceRequest.location`
5. لا تخزين `addressId` على الطلب

### 4.3 HTTP — `request_routes.ts`

- `asOptionalAddressId(body.addressId)` بدل `optionalBodyField`

### 4.4 DI — `composition_root.ts`

- `new CreateRequestUseCase(requestRepository, addressRepository)`

### 4.5 التوثيق — `docs/API.md` §6.1

- Option A: `addressId`
- Option B: `location`
- استبعاد متبادل + سلوك الأخطاء

## 5. تعديلات Flutter

### `request_json.dart` — `buildCreateRequestBody`

```dart
if (address != null && address.id.trim().isNotEmpty) {
  body['addressId'] = address.id.trim();
} else if (address has lat/lng) {
  body['location'] = { latitude, longitude };
}
```

- لا يُرسل الحقلان معًا
- fallback `location` للعناوين بلا `id`
- fallback الوصف الفارغ `بدون وصف` (Sprint 1+2) دون تغيير

## 6. الملفات المعدّلة

### Backend (`otlob-platform`)

| الملف | التغيير |
|---|---|
| `backend/modules/requests/application/dto/requests/request_request.ts` | `addressId` مدعوم |
| `backend/modules/requests/application/use_cases/commands/create_request_use_case.ts` | حل العنوان |
| `backend/functions/src/composition_root.ts` | DI |
| `backend/functions/src/http/routes/request_routes.ts` | `asOptionalAddressId` |
| `backend/functions/src/http/routes/request_routes.test.ts` | 3 حالات HTTP جديدة |
| `backend/functions/src/http/routes/catalog_routes.test.ts` | DI |
| `backend/functions/src/http/routes/address_routes.test.ts` | DI |
| `backend/modules/requests/tests/unit/request_validation.test.ts` | 5 حالات unit |
| `backend/modules/requests/tests/unit/request_use_cases.test.ts` | DI |
| `docs/API.md` | §6.1 |

### Flutter (`otlob-customer-app`)

| الملف | التغيير |
|---|---|
| `lib/features/requests/data/http/request_json.dart` | `addressId` أولًا |
| `test/features/requests/request_json_test.dart` | 3 اختبارات |
| `test/features/requests/http_customer_request_repository_test.dart` | يتوقع `addressId` |
| `test/features/requests/request_flow_controller_test.dart` | يتوقع `addressId` |

## 7. الاختبارات

### Backend

```text
npm run build:core && npm run build:domain
npm test -w @otlob/backend          → 43 pass
npm run sync:vendor && npm test -w @otlob/functions → 25 pass
```

حالات Sprint 3 الجديدة:

| الاختبار | النتيجة المتوقعة |
|---|---|
| `addr-001` → إحداثيات المنزل | `location: {24.7136, 46.6753}`، لا `addressId` في الرد |
| `addressId` غير معروف | `404 not_found` |
| عنوان عميل آخر | `404 not_found` |
| `addressId` + `location` | `400 validation_failed` |
| عنوان بلا إحداثيات | `400 validation_failed` |
| `location` مباشر (Sprint 1) | يعمل كما كان |

### Flutter

```text
flutter test                        → 90 pass
flutter analyze (requests)          → info فقط (directives_ordering)
```

## 8. سلوك API بعد النشر

**طلب إنشاء (Option A):**

```http
POST /v1/requests
Content-Type: application/json

{
  "serviceId": "pipe-repair",
  "description": "Kitchen leak",
  "addressId": "addr-001"
}
```

**رد 201:**

```json
{
  "data": {
    "id": "req-004",
    "location": { "latitude": 24.7136, "longitude": 46.6753 },
    ...
  }
}
```

لا يوجد `addressId` في الرد.

## 9. خطوات النشر والتحقق اليدوي (Mac)

```bash
# Backend
cd /Users/shatii/otlob-platform
git checkout cursor/sprint3-addressid-0cf4
firebase deploy --only functions:api --project otlob-platform-dev

# Flutter
cd /Users/shatii/otlob-customer-app
git checkout cursor/sprint3-addressid-0cf4
flutter run -d "iPhone 16 Pro" --dart-define=API_BASE_URL=https://api-lfp2bv24wq-ew.a.run.app
```

**E2E:**

1. اختر خدمة → اختر `addr-001` → أرسل
2. تأكد POST يحتوي `addressId` فقط (لا `location`)
3. `GET /v1/requests/{id}` → إحداثيات محلولة، لا `addressId`

## 10. الفروع

- `cursor/sprint3-addressid-0cf4` على كلا المستودعين من `main`

## 11. الافتراضات

- العميل: `offline-customer`
- العنوان التجريبي: `addr-001` → `{24.7136, 46.6753}`
- `location` المباشر يبقى للتوافق

## 12. القيود المعروفة

- النشر على Cloud Run مطلوب لتفعيل `addressId` على الـ API الحي
- InMemory repos تُصفَّر عند cold start
- لا iPhone Simulator في بيئة Cloud Agent

## 13. المؤجّل (Sprint 4+)

- Auth + Firestore
- Publish / matching / offers
- تخزين snapshot للعنوان على الطلب (إن طلب المنتج لاحقًا)
