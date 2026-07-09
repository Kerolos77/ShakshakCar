# توثيق أحداث البث المباشر (Real-Time) لرحلات الشحن 🚀

هذا الملف يوضح تفاصيل قنوات البث المباشر (WebSockets/Pusher) الخاصة برحلات الشحن الجديدة للدرايفر والعميل، القنوات المستخدمة، متى يتم الإرسال، وشكل البيانات الراجعة.

---

## 1. قناة إشعارات رحلات الشحن الجديدة للسائقين (Driver Shipping Channel)
قناة خاصة بكل سائق (Private Channel) لإشعاره بوجود رحلة شحن جديدة ومتاحة متوافقة مع نوع سيارته ونطاقه الجغرافي.

* **نوع القناة:** Private (تتطلب تصديق Auth عبر `/api/broadcasting/auth` بـ Bearer Token الخاص بالسائق).
* **اسم القناة (Pusher Channel):** `private-driver-shipping.{driver_id}`
* **اسم الحدث (Event Name):** `TripStatusUpdated`
* **وقت الإرسال (Trigger):** يتم الإرسال فور قيام العميل بإنشاء طلب شحن جديد وتكون حالة الطلب `pending`.

### شكل البيانات المرسلة (Payload):
```json
{
  "status": "pending",
  "order": {
    "id": 970,
    "destination_lat": "30.0444",
    "destination_long": "31.2357",
    "destination_address": "Cairo Airport",
    "source_lat": "30.0130",
    "source_long": "31.2082",
    "source_address": "Tahrir Square, Cairo",
    "amount": "150",
    "final_rate": "150",
    "distance": "18.5",
    "distance_type": "km",
    "status": "pending",
    "offerdriver": "",
    "is_offer": "",
    "created_at": "2026-06-13T14:43:06+03:00",
    "driver": "",
    "user": {
      "id": 1,
      "name": "Test User",
      "phone": "+201001234567"
    },
    "when_date": "2026-06-14 10:00:00",
    "inter_city": 0,
    "user_service_id": 1,
    "paid": 0,
    "payment_type": "cash",
    "commission": "0",
    "parcel_dimension": "10x10x10",
    "parcel_weight": "5",
    "parcel_image": "https://shakshak.net/uploads/image.jpg",
    "comment": "Fragile items",
    "is_shipping_order": 1,
    "receiver_name": "John Doe",
    "receiver_phone": "+20123456789",
    "pickup_otp": "", // تظهر للعميل فقط لحماية الشحنة
    "delivery_otp": "" // تظهر للعميل وللمستلم فقط
  }
}
```

---

## 2. قناة تتبع الرحلة المحددة (Specific Trip Channel)
قناة عامة (Public Channel) يشترك فيها العميل والسائق لمتابعة تحديثات وحالات رحلة شحن معينة خطوة بخطوة.

* **نوع القناة:** Public.
* **اسم القناة (Pusher Channel):** `trip-{trip_id}`
* **اسم الحدث (Event Name):** `TripStatusUpdated`
* **وقت الإرسال والخطوات (Milestones):**

### أ. عند وصول السائق لموقع الشاحن (موقع الاستلام):
* **التأثير:** تحديث حالة الرحلة إلى `arrived` وتسجيل توقيت وصول السائق.
* **الحالة (`status`):** `arrived`
* **التوقيت المحدث:** `driver_arrived_at_sender_at`

### ب. عند تسليم الشحنة للسائق والتحقق من كود الاستلام (Pickup OTP):
* **التأثير:** يتم التحقق من كود الاستلام بنجاح، وتتحول حالة الرحلة إلى "جاري التوصيل" (`on_trip`) وتسجيل توقيت بدء الرحلة الفعلي.
* **الحالة (`status`):** `on_trip`
* **التوقيتات المحدثة:**
  * `sender_confirmed_handover_at` (تأكيد تسليم الشاحن للشحنة)
  * `driver_confirmed_pickup_at` (تأكيد استلام السائق للشحنة)
  * `on_trip_at` (بدء الرحلة الفعلي)
  * `driver_confirmed_cash_at` (إذا كان الدفع كاش، يتم تسجيل وقت استلام الكاش من الشاحن)

### ج. عند وصول السائق لموقع المستلم (Receiver Location):
* **التأثير:** تسجيل توقيت وصول السائق للمستلم.
* **الحالة (`status`):** تبقى `on_trip`
* **التوقيت المحدث:** `driver_arrived_at_receiver_at`

### د. عند تسليم الشحنة للمستلم والتحقق من كود التسليم (Delivery OTP):
* **التأثير:** انتهاء رحلة الشحن بنجاح وتغيير حالة الرحلة إلى `completed`.
* **الحالة (`status`):** `completed`
* **التوقيتات المحدثة:**
  * `driver_confirmed_delivery_at` (تأكيد السائق للتسليم)
  * `receiver_confirmed_delivery_at` (تأكيد المستلم للاستلام)
  * `completed_at` / `is_end` (وقت اكتمال الطلب)

---

## 3. حقول الاستجابة الخاصة بالشحن (Shipping-Specific API Response Fields)
تضم استجابة تفاصيل الرحلة الحقول الجديدة التالية:

| الحقل | الوصف | الجهة التي تراه |
|---|---|---|
| `is_shipping_order` | قيمته `1` إذا كان طلب شحن، و `0` إذا كانت رحلة عادية. | الجميع |
| `receiver_name` | اسم الشخص المستلم للشحنة. | الجميع |
| `receiver_phone` | رقم هاتف الشخص المستلم للشحنة. | الجميع |
| `pickup_otp` | كود الاستلام (4 أرقام). | العميل (الشاحن) فقط |
| `delivery_otp` | كود التسليم (4 أرقام). | العميل (الشاحن) والمستلم فقط |
| `parcel_dimension` | أبعاد الشحنة. | الجميع |
| `parcel_weight` | وزن الشحنة. | الجميع |
| `parcel_image` | رابط صورة الشحنة. | الجميع |
| `comment` | ملاحظات إضافية حول الشحنة. | الجميع |
