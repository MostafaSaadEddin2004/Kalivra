# Kalivra API Reference

**Base URL:** `https://test1.zedan-world.com/api/`

---

## 1. APIs currently used in the app

| # | Method | Path | Full URL | Service | Purpose |
|---|--------|------|----------|---------|---------|
| 1 | GET | `products` | https://test1.zedan-world.com/api/products | ProductApiService | List products (optional: `category_id`) |
| 2 | GET | `products/{id}` | https://test1.zedan-world.com/api/products/{id} | ProductApiService | Single product by ID |
| 3 | GET | `categories` | https://test1.zedan-world.com/api/categories | CategoryApiService | List categories |
| 4 | GET | `customer` | https://test1.zedan-world.com/api/customer | CustomerApiService | Get customer profile |
| 5 | POST | `customer/login` | https://test1.zedan-world.com/api/customer/login | CustomerApiService | Login (email, password) |
| 6 | POST | `customer/register` | https://test1.zedan-world.com/api/customer/register | CustomerApiService | Register (name, email, phone, password, password_confirmation) |
| 7 | POST | `customer/logout` | https://test1.zedan-world.com/api/customer/logout | CustomerApiService | Logout |
| 8 | PUT | `customer` | https://test1.zedan-world.com/api/customer | CustomerApiService | Update profile (name, phone, address, city, country) |
| 9 | GET | `customer/addresses` | https://test1.zedan-world.com/api/customer/addresses | AddressApiService | List customer addresses |
| 10 | POST | `customer/addresses` | https://test1.zedan-world.com/api/customer/addresses | AddressApiService | Create address |
| 11 | GET | `orders` | https://test1.zedan-world.com/api/orders | OrderApiService | List orders |
| 12 | GET | `orders/{id}` | https://test1.zedan-world.com/api/orders/{id} | OrderApiService | Single order by ID |
| 13 | GET | `orders/{orderId}/invoices` | https://test1.zedan-world.com/api/orders/{orderId}/invoices | OrderApiService | List invoices for an order |
| 14 | GET | `orders/{orderId}/shipments` | https://test1.zedan-world.com/api/orders/{orderId}/shipments | OrderApiService | List shipments for an order |
| 15 | GET | `orders/{orderId}/transactions` | https://test1.zedan-world.com/api/orders/{orderId}/transactions | OrderApiService | List transactions for an order |
| 16 | GET | `cart` | https://test1.zedan-world.com/api/cart | CartApiService | Get cart |
| 17 | POST | `cart/items` | https://test1.zedan-world.com/api/cart/items | CartApiService | Add item (product_id, quantity, options) |
| 18 | PUT | `cart/items/{itemId}` | https://test1.zedan-world.com/api/cart/items/{itemId} | CartApiService | Update item quantity |
| 19 | DELETE | `cart/items/{itemId}` | https://test1.zedan-world.com/api/cart/items/{itemId} | CartApiService | Remove item from cart |
| 20 | GET | `wishlist` | https://test1.zedan-world.com/api/wishlist | WishlistApiService | Get wishlist |
| 21 | POST | `wishlist` | https://test1.zedan-world.com/api/wishlist | WishlistApiService | Add to wishlist (product_id) |
| 22 | DELETE | `wishlist/{itemId}` | https://test1.zedan-world.com/api/wishlist/{itemId} | WishlistApiService | Remove from wishlist |
| 23 | POST | `checkout` | https://test1.zedan-world.com/api/checkout | CheckoutApiService | Submit checkout (body) |
| 24 | GET | `countries` | https://test1.zedan-world.com/api/countries | CountryApiService | List countries (and states) |
| 25 | GET | `configurations` | https://test1.zedan-world.com/api/configurations | ConfigApiService | Get store configuration |
| 26 | GET | `locales` | https://test1.zedan-world.com/api/locales | LocaleApiService | List supported locales |
| 27 | GET | `currencies` | https://test1.zedan-world.com/api/currencies | CurrencyApiService | List currencies |

---

## 2. APIs needed but not implemented / not used in the app

These are required by app flows or would improve the app but have **no corresponding API service or endpoint** in the codebase yet:

| # | Suggested path | Method | Purpose |
|---|----------------|--------|---------|
| 1 | `customer/forgot-password` or `auth/forgot-password` | POST | Forgot password: send OTP/reset link to phone or email (used from login & change-password screen) |
| 2 | `customer/verify-otp` or `auth/verify-otp` | POST | Verify OTP code (sign-up, forgot password, change phone) |
| 3 | `customer/send-otp` or `auth/send-otp` | POST | Send OTP to phone (used in OtpPhoneEntryScreen for sign-up, forgot password, change phone) |
| 4 | `customer/change-password` or `auth/change-password` | POST | Change password when user is logged in (ChangePasswordScreen) |
| 5 | `customer/set-password` or `auth/reset-password` | POST | Set new password after OTP verification (forgot-password flow) |
| 6 | `customer/change-phone` or `customer/verify-new-phone` | POST | Confirm new phone after OTP (change-phone flow) |
| 7 | `referral/submit` or `customer/referral` | POST | Submit referral code to backend (ReferralRepository only stores locally; no API call) |
| 8 | `referral/my-code` or `customer/referral-code` | GET | Get current user’s referral code from server (app uses mock/local only) |
| 9 | `notifications` | GET | List notifications for the user (NotificationsCubit has no API; only checks token) |
| 10 | `notifications/{id}/read` or `notifications/read` | POST/PUT | Mark notification(s) as read (if notifications API exists) |

---

## Summary

- **Used:** 27 endpoints across products, categories, customer, addresses, orders, cart, wishlist, checkout, countries, configurations, locales, currencies.
- **Needed / missing:** Forgot password, send OTP, verify OTP, change password, set new password, change/verify phone, referral submit & get code, notifications list (and optionally mark read).
