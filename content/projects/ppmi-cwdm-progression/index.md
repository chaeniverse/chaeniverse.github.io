---
title: "Future DaTScan Synthesis for Parkinson's Progression with Conditional Wavelet Diffusion"
date: 2026-05-01
summary: "DaTScan 한 장으로 2년 후 영상을 합성하는 conditional wavelet diffusion 프레임워크 (한국통계학회 포스터, 1저자)."
tags:
  - Deep Learning
  - Generative AI
  - Neuroimaging
tech_stack:
  - Python
  - PyTorch
  - Conditional Wavelet Diffusion Model
  - 3D Haar Wavelet
  - DDPM
links:
  - type: github
    url: https://github.com/chaeniverse/cwdm
    label: Code
featured: true
status: "Presentation (Poster)"
role: "1저자"
duration: "2025–2026"
highlights:
  - "DaTScan 한 장으로 2년 후 영상을 합성하는 conditional wavelet diffusion 프레임워크"
---

#### 개요

파킨슨병(Parkinson's disease, PD) 환자의 도파민 신경 퇴행 진행을 예측하기 위한 딥러닝 프레임워크입니다. 초기(screening) DaTScan SPECT 영상 한 장을 조건으로 2년 후(V04) 시점의 DaTScan 영상을 합성해, 반복 촬영 없이 개인 수준의 진행 양상을 시각적으로 예측합니다.

기존 연구는 미래 UPDRS 점수 등 **수치 예측**에 그쳤지만, 본 연구는 **영상 자체를 생성**해 도파민 손실의 공간적 분포를 정성적으로도 보여줍니다. 임상에서 의사가 영상을 직접 판독해 진단하는 현실을 고려하면 정량 + 정성 모두 의미가 있습니다.

#### 배경

DaTScan은 파킨슨병 진단의 핵심 영상 바이오마커지만, 방사선 피폭, 추적자 주입 후 3–6시간 대기, 핵의학 장비 접근성, 운동 증상이 진행된 환자의 SPECT 자세 유지 어려움 등으로 종단적(longitudinal) 추적 촬영에 실질적 제약이 따릅니다. 초기 영상만으로 미래 시점의 도파민 분포 패턴을 예측할 수 있다면, 불필요한 반복 촬영 없이 개인화된 예후 예측과 조기 예방적 권고가 가능해집니다.

#### 데이터

- **출처**: Parkinson's Progression Markers Initiative (PPMI)
- **구성**: 스크리닝(SC) 시점과 2년 후(V04) 시점의 DaTScan SPECT 영상 쌍, 품질 관리 후 **746쌍**
- **전처리**: 공간 정규화 + 강도 정규화
- **분할**: train / validation / test = 7 : 1.5 : 1.5

#### 방법론

**조건부 웨이블릿 확산 모델 (cWDM).** Friedrich et al. (2024)의 cWDM 프레임워크를 적용했습니다. 학습 기반 오토인코더와 달리 웨이블릿 변환은 **정보 손실 없이** 영상을 저주파(전체 구조)와 고주파(세밀한 디테일) 성분으로 분해하고, 역변환으로 완벽 복원합니다.

**3D Haar Wavelet.** 128³ 복셀 영상을 64³ × 8채널의 웨이블릿 계수로 분해해 모든 정보를 보존하면서 연산량을 크게 줄였습니다.

**손실 함수.** 표준 DDPM noise prediction loss:

$$\mathcal{L} = \mathbb{E}_{t, \mathbf{x}_0, \boldsymbol{\epsilon}} \big[\, \|\boldsymbol{\epsilon} - \boldsymbol{\epsilon}_\theta(\mathbf{x}_t, t, \mathbf{c})\|^2 \,\big]$$

조건 변수 **c** 는 baseline (SC 시점) DaTScan 영상입니다.

#### 평가 지표

- **영상 품질**: PSNR, SSIM, RMSE
- **임상적 유효성**: Striatal Binding Ratio (SBR) — 미상핵(caudate), 피각(putamen), 피각/미상핵 비율(P/C ratio)
- **정성 평가**: 임상용 color lookup table을 적용해 baseline · 실제 V04 · 합성 V04 비교

#### 결과

테스트 세트(n = 112)에서 합성된 V04 영상의 정량 성능:

- **PSNR**: 21.99 ± 2.40 dB
- **SSIM**: 0.6452 ± 0.065

부위별 SBR은 실제 추적 영상과 강한 상관을 보였습니다:

- **전체 선조체(striatum)**: r = 0.676, p < 0.001
- **미상핵(caudate)**: r = 0.699, p < 0.001
- **피각(putamen)**: r = 0.660, p < 0.001
- **피각/미상핵 비율 (P/C ratio)**: r = 0.670, p < 0.001

임상용 color scale을 적용한 정성적 비교에서, 합성 영상은 선조체 영역의 전반적 섭취 위치를 반영하였으나 세부 구조의 선명도에는 한계가 있었습니다.

#### 결론

단일 초기 DaTScan 영상으로부터 2년 후 영상을 합성하는 딥러닝 프레임워크를 제시했고, 피각/미상핵 비율을 포함한 부위별 진행 지표에서 실제 추적 영상과 유의한 상관관계를 확인했습니다. 향후 임상 변수와의 결합을 통해 개인화된 파킨슨병 진행 예측 모델로 확장될 수 있습니다.

#### 성과

이채현, 이기림, 정봉기, 최수인, 박보용, "딥러닝 기반 파킨슨병 도파민 수송체 영상의 종단적 진행 예측: 조건부 웨이블릿 확산 모델을 활용한 미래 DaTScan 영상 합성", *한국통계학회*, 2026 (포스터, 1저자).
