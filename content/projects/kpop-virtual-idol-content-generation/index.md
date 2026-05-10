---
title: "Content Image Generation"
date: 2026-04-06
summary: "K-Pop 가상 아이돌 콘텐츠 컷 이미지 생성 실험."
tags:
  - App/Service
  - Image Generation
  - Generative AI
  - Prompt Engineering
authors:
  - me
tech_stack:
  - Python
  - Image Generation Model
  - Prompt Engineering
links:
  - type: github
    url: https://github.com/chaeniverse/kpop-image-experiments
    label: Implementation
featured: true
status: "Completed"
role: "분석·실험 담당"
duration: "2026 진행 중"
highlights:
  - "K-Pop 가상 아이돌 콘텐츠 컷 이미지 생성 실험"
---

## 개요

K-Pop 가상 아이돌 앱 프로젝트의 일부로 진행한 **콘텐츠 이미지 생성** 실험입니다. 가상 아이돌에게 다양한 scene을 입히면서도 캐릭터(얼굴) 정체성은 변하지 않도록, prompt 설계·reference conditioning·격자 탐색을 결합해 검증했습니다.

> **보안 안내.** 본 프로젝트는 일부 대외비 작업이 포함되어, 실제 prompt 전문·생성 이미지·캐릭터 식별 정보는 공개하지 않습니다. 본 페이지는 **실험 설계와 방법론** 중심으로 정리합니다.

## 실험 목적

> *"같은 캐릭터(얼굴)를 유지하면서, 다양한 scene의 콘텐츠 컷을 일관되게 생성할 수 있는가?"*

- **일관성 (consistency)** — 캐릭터의 얼굴이 scene이 바뀌어도 같은 사람으로 인식되어야 함
- **다양성 (variety)** — 같은 캐릭터라도 scene·구도·의상이 자연스럽게 변주되어야 함
- **콘셉트 표현** — 각 scene의 분위기 (일상의 자연스러움, 상황감, 아이돌 포즈) 가 prompt만으로 전달되어야 함

## 실험 설계

### 신(Scene) 3종

| 신 ID | 콘셉트 | 목적 |
|---|---|---|
| **Scene #1** | 일상, 자연스러움 | 자연스러운 표정 자세로 친근감 형성 |
| **Scene #2** | 시그니처 포즈 | 팬 인터랙션용 정형 포즈 일관성 검증 |
| **Scene #3** | 특정 장소 배경 | 콘셉트가 강한 narrative 컷의 prompt 표현력 검증 |

### Reference-Image Conditioning

각 콘텐츠 컷 생성 시 유저가 생성한 캐릭터 ID 사진을 reference로 함께 입력해, **얼굴 정체성 유지** 를 강제합니다. Prompt 앞단에 다음과 같은 지침을 둡니다 (요약):

> *Keep the person's facial features exactly the same as the reference image. This is the same person, not a look-alike or approximation.*

이를 통해 gemini의 image-to-image 모드에서 동일 인물성을 안정적으로 보장.

### Combo 변주

각 신 안에서 **combo (조합)** 단위로 prompt 변종을 둡니다 — 의상 / 헤어 등 hyperparameter를 격자 탐색 형태로 변형. 동일 character × 동일 combo에서 **trial 반복** 으로 생성 안정성도 같이 본다.

### 생성 규모

| 실험 | 생성 이미지 수 |
|---|---|
| Scene #1 | ≈ 1,249 장 |
| Scene #2 | ≈ 937 장 |
| Scene #3 | ≈ 1,041 장 |
| **총합** | **≈ 3,200 장** |

각 이미지는 384×688 해상도, 평균 약 9–11초 / 장 소요, 장당 비용 약 $0.045 수준.

## 결과 분석 관점

- **얼굴 일관성** — 헤어 색·길이는 prompt에 명시적 제약 (`Do NOT alter the hairstyle color or length`) 을 둬야 안정적이었다.
- **포즈 정확성** — 손가락 위치·구도가 변동성이 큼. 별도 negative prompt (e.g., `no extra fingers`) 로 보완.
- **콘셉트 강도** — 장소 디테일은 prompt에 명시적으로 포함시킬수록 narrative가 살아나지만, 그만큼 얼굴 영역의 픽셀 비율이 줄어 정체성 손실 위험 증가 → reference 가중치 / 카메라 거리 prompt를 같이 조정.

## 실험 흐름 (자동화)

각 sprint는 다음 자동화 파이프라인 위에서 돌렸습니다.

1. **Prompt template 정의** — scene별 system prompt + character 변수 슬롯
2. **Combo grid expansion** — Python으로 character × combo × trial 격자 생성
3. **API 호출** — image+text → image
4. **HTML report 자동 생성** — combo 단위로 시각적으로 묶어 검수 가능한 리포트

## Stack

- **Python** — 실험 파이프라인 (combo grid, API 호출, HTML report 생성)
- **Gemini Flash Image Preview** — 이미지 생성 모델
- **Prompt Engineering** — system prompt + reference conditioning + negative constraints

