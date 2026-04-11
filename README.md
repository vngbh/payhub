# Divpay

Divpay la ung dung iOS giup chia tien cho mot nhom nguoi sau mot buoi an uong, di choi, du lich ngan ngay, hoac bat ky chi phi chung nao. Muc tieu san pham la nhap chi phi nhanh, biet ai da tra, ai can tra lai cho ai, va giam so giao dich can chuyen tien.

## Trang thai hien tai

- Nen tang: iOS / iPadOS
- UI framework: SwiftUI
- Project: Xcode project (`divpay.xcodeproj`)
- App target: `divpay`
- Unit test target: `divpayTests`
- UI test target: `divpayUITests`
- Bundle ID: `com.vngbh.divpay`
- Version hien tai: `1.0` build `1`
- iOS deployment target hien tai: `26.2`

## Yeu cau moi truong

- macOS co cai Xcode day du, khong chi Command Line Tools.
- Xcode phien ban ho tro iOS deployment target cua project.
- iOS Simulator duoc cai trong Xcode.
- Apple Developer account neu muon build len thiet bi that, TestFlight, hoac App Store.

Kiem tra toolchain:

```sh
xcode-select -p
xcodebuild -version
```

Neu `xcodebuild` bao loi dang nhu `tool 'xcodebuild' requires Xcode, but active developer directory ... is a command line tools instance`, chuyen developer directory sang Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

Sau do kiem tra lai:

```sh
xcodebuild -version
```

## Mo project de phat trien

Mo bang Xcode:

```sh
open divpay.xcodeproj
```

Trong Xcode:

1. Chon scheme `divpay`.
2. Chon simulator, vi du `iPhone 17` hoac mot simulator kha dung tren may.
3. Bam `Cmd + R` de build va chay app.
4. Bam `Cmd + U` de chay test.

## Lenh co ban

Liet ke scheme, target va configuration:

```sh
xcodebuild -list -project divpay.xcodeproj
```

Liet ke simulator kha dung:

```sh
xcrun simctl list devices available
```

Mo Simulator:

```sh
open -a Simulator
```

Build Debug cho iOS Simulator:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  build
```

Chay unit test va UI test tren simulator:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Neu may khong co `iPhone 17`, thay bang ten simulator trong ket qua cua:

```sh
xcrun simctl list devices available
```

Xoa build cache rieng cua project khi gap loi build la:

```sh
rm -rf ~/Library/Developer/Xcode/DerivedData/divpay-*
```

## Chay app tren simulator bang command line

Cach don gian nhat la dung Xcode voi `Cmd + R`. Khi can automation, co the build roi install app vao simulator.

Boot simulator:

```sh
xcrun simctl boot 'iPhone 17'
open -a Simulator
```

Build app vao thu muc rieng:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath build/DerivedData \
  build
```

Install va launch app:

```sh
xcrun simctl install booted build/DerivedData/Build/Products/Debug-iphonesimulator/divpay.app
xcrun simctl launch booted com.vngbh.divpay
```

## Quy trinh phat trien de vibe coding

Moi vong lam viec nen di theo nhip sau:

1. Chon mot muc tieu nho, vi du `tao man hinh them hoa don`, `tinh so tien moi nguoi can tra`, hoac `luu danh sach thanh vien`.
2. Cap nhat code.
3. Build tren simulator.
4. Chay test lien quan.
5. Tu test luong chinh tren simulator.
6. Commit khi app build duoc va hanh vi on.

Lenh kiem tra truoc khi commit:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Commit goi y:

```sh
git status
git add .
git commit -m "Build initial bill splitting flow"
```

## Kien truc de giu project gon

Khi app lon hon, nen tach code theo cac lop sau:

- `Models`: du lieu chinh nhu group, member, expense, split result.
- `Views`: SwiftUI screen va component.
- `ViewModels`: state va logic dieu phoi cho tung man hinh.
- `Services`: tinh toan chia tien, luu tru, import/export.
- `Tests`: test logic chia tien va cac edge case.

Logic chia tien nen duoc viet o lop thuan Swift de test duoc bang unit test, tranh de logic nam qua nhieu trong SwiftUI view.

## Checklist tinh nang MVP

- Tao nhom.
- Them thanh vien.
- Them khoan chi: ten, so tien, nguoi tra, nguoi tham gia.
- Tinh tong tien moi nguoi da tra.
- Tinh so tien moi nguoi thuc su phai chiu.
- De xuat giao dich toi thieu: ai chuyen cho ai bao nhieu.
- Sua/xoa khoan chi.
- Luu du lieu local.
- Man hinh tong ket de share ket qua.

## Test can co

Unit test nen uu tien cac case:

- Tat ca thanh vien chia deu mot hoa don.
- Mot nguoi tra nhieu hoa don cho ca nhom.
- Mot hoa don chi co mot so thanh vien tham gia.
- So tien le va lam tron.
- Tong tien nhan ve bang tong tien can tra.
- Khong tao giao dich khi tat ca da can bang.

UI test nen bao phu:

- Launch app thanh cong.
- Tao group moi.
- Them expense moi.
- Xem ket qua chia tien.

## Build Release

Build Release cho simulator de bat loi compile:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  build
```

Archive de upload TestFlight/App Store:

```sh
xcodebuild \
  -project divpay.xcodeproj \
  -scheme divpay \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/divpay.xcarchive \
  archive
```

Export archive can co file `ExportOptions.plist` phu hop voi cach phan phoi (`development`, `ad-hoc`, `app-store-connect`, hoac `enterprise`). Vi project chua co file nay, tao khi bat dau TestFlight/App Store.

```sh
xcodebuild \
  -exportArchive \
  -archivePath build/divpay.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

## Checklist truoc TestFlight

- Cap nhat `MARKETING_VERSION` va `CURRENT_PROJECT_VERSION`.
- Dat bundle ID dung voi Apple Developer portal.
- Cau hinh signing team trong Xcode.
- Them app icon day du.
- Kiem tra launch screen.
- Chay unit test va UI test.
- Test tren it nhat mot iPhone simulator va mot iPad simulator neu tiep tuc support iPad.
- Test tren thiet bi that neu co.
- Viet mo ta ban build: tinh nang moi, loi da biet, luong can test.

## Troubleshooting

Kiem tra Xcode dang duoc chon:

```sh
xcode-select -p
```

Kiem tra simulator co ton tai:

```sh
xcrun simctl list devices available
```

Reset simulator dang boot:

```sh
xcrun simctl shutdown booted
xcrun simctl erase booted
```

Neu `xcrun simctl erase booted` bao loi vi khong co simulator dang boot, hay boot simulator truoc hoac erase theo device ID trong danh sach simulator.

Kiem tra git truoc khi commit:

```sh
git status --short
git diff
```

