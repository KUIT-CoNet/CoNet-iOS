# CoNet-iOS

![1](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/9d781b3b-b73d-461e-acb1-973e1d037175)

<br><br>

## 💜 CoNet

### 팀명/서비스명 : CoNet (커넷)

Connect와 Network를 합친 단어로<br>
사람들 간 만남, 이전의 약속과 앞으로의 약속 모두를 이어 과거부터 미래까지 연결해주는 역할을 의미합니다.

### 역할/담당

| 파트 | 이름 | 역할 및 담당 |
| --- | --- | --- |
| PM/iOS | [이안진](https://github.com/anjiniii) | 🍎 기획/프로젝트 매니징 및 iOS 개발 |
| iOS | [정아현](https://github.com/ahhyun1015) | 🍎 iOS 개발 |
| iOS | [유가은](https://github.com/slr-09) | 🍎 iOS 개발 |
| Android | [김영록](https://github.com/kimyeoungrok) | 🤖 Android 개발 Lead |
| Android | [박지원](https://github.com/parkji1on) | 🤖 Android 개발 |
| Android | [김채린](https://github.com/chrin05) | 🤖 Android 개발 |
| Server | [정소민](https://github.com/somin-jeong) | 💻 Server 개발 Lead |
| Server | [정경은](https://github.com/ro-el-c) | 💻 Server 개발 |
| Design | 김미보 | 📢 서비스 디자인 |

<br>

## 🗓️ Development project timeline

전체 프로젝트 기간
2023.06.26 - 2023.08.10

<br>

## 💡 Pain Point & Solution

> CoNet은 약속을 잡는 순간부터 약속을 기록하는 마지막까지 전반적으로 관리를 도와줍니다.

1. 서로 다른 스케줄로 시간을 맞추는 데 어려움<br>
=> 시각적으로 한 눈에 볼 수 있는 시간표

2. 과거의 약속을 잊거나 정리가 되지 않음<br>
=> 지난 약속까지 모두 볼 수 있는 히스토리

3. 약속을 정하는 과정에서 여러 플랫폼 사용 필요<br>
=> 모든 스케줄을 한 공간에서 관리

<br>

## 💫 Features

<details>
<summary>로그인/회원가입, 홈 화면(캘린더, 약속 리스트)</summary>


-  iOS에서는 애플과 카카오, Android에서는 카카오로 간편하게 앱을 시작할 수 있습니다.
-  약관 동의와 이름 입력으로 회원가입을 하고 나면, 홈 화면에서는 모든 모임에 대한 확정된 약속과 확정을 기다리고 있는 대기중인 약속을 확인할 수 있습니다.

![15](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/22f3a58e-e037-49be-b3d4-6a2d1a419691)

</details>

<details>
<summary>모임 만들고, 참여하기</summary>

- 모임 이름과 대표 사진을 입력해 모임을 만들고, 초대코드를 발급해 함께 하고 싶은 친구들에게 공유합니다.
- 초대코드는 영어 대소문자와 숫자로 이루어진 8글자의 코드로, 발급 시각으로부터 24시간까지 유효합니다.
- 전달받은 초대코드를 입력하면 모임에 참여할 수 있습니다.

![16](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/c06bea5f-95f1-48bb-9631-3070033c0888)

</details>

<details>
<summary>약속 만들기</summary>

- 약속 이름과 약속이 이루어질 것 같은 기간의 시작 날짜를 입력하고 약속을 생성합니다.
- 만들어진 약속은 모임원들의 대기중인 약속으로 나타납니다.
  
![17](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/2b50420f-8e2a-410b-8b35-e8da3c70baa3)

</details>

<details>
<summary>가능한 시간 입력하고 모임원들에게 시간 공유하기</summary>

- 대기 중인 약속에서 모임원들이 이 기간에 가능한 시간을 확인할 수 있습니다.
- 내 시간을 입력/수정할 수 있고, 가능한 시간이 없다면 아래 가능한 시간 없음 버튼을 누르고 저장할 수 있습니다.
- 시간 공유 페이지에서는, 가능한 사람의 수에 따라 색상을 다르게 지정하여, 시간대별 가능한 사람들의 수를 쉽게 확인할 수 있도록 했습니다.

![18](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/4ccc5c27-efef-43af-8211-215cd419c34c)

</details>

<details>
<summary>약속 확정하기</summary>

- 시간 공유 페이지에서 가능한 사람이 있는 시간대를 선택하면, 해당 시간에 누가 가능한지 확인하고, 약속을 확정할 수 있습니다.
- 확정된 약속은 캘린더에 기록되어 홈 탭과 모임 안에서 확인할 수 있습니다.

![19](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/043fa4b0-ee2b-45f9-88a8-b3ad6e2bc32c)

</details>

<details>
<summary>히스토리</summary>

- 확정된 약속의 날짜가 지나고 나면 약속에 대한 추억을 기록할 수 있습니다.
- 히스토리 추가를 통해 사진과 내용을 입력하면, 그동안 모임에서 함께 해왔던 기억들을 피드 형태로 모아볼 수 있습니다.

![20](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/7309425a-56a8-4542-85fa-23c22d65b049)

</details>
<br><br>

## 💻 Technologies Used
- `iOS`
  - Xcode, Swift
  - UIKit
  - SnapKit, Then, Alamofire

<br>

## 🏙️ System Architecture

![21](https://github.com/KUIT-CoNet/CoNet-iOS/assets/117328806/ffd5ec92-9c73-4557-af7d-54f0b9f0abde)

