---
title: "Casting Image Generation"
date: 2026-05-02
summary: "K-Pop 가상 아이돌 연습생 이미지 생성 과정."
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
duration: "2026.03 – 2026.05"
highlights:
  - "K-Pop 가상 아이돌 연습생 이미지 생성 과정"
---

## 개요

K-Pop 가상 아이돌 앱의 캐릭터를 캐스팅하기 위한 이미지 생성 프로젝트. **얼굴·스타일·분위기 일관성** 을 만족하는 트레이니 후보군을 prompt 설계 + 반복 생성 + 정성 평가로 좁혀나갔습니다.

> **보안 안내.** 본 프로젝트는 일부 대외비 작업이 포함되어, 실제 prompt 전문·생성 이미지·캐릭터 식별 정보는 공개하지 않습니다. 본 페이지는 **실험 단계와 방법론** 중심으로 정리합니다.

## 단계별 진화

### Step 1 — 초기 캐스팅 prompt 설계

목표: 가상 아이돌 트레이니의 변수 축을 prompt 변수로 정의하고, 그 격자로 후보 군을 만드는 것.

변수 축 (공개 가능 범위):

- 인종 (Race)
- 성별 (Gender)
- 분위기 (Mood)
- (그 외 축은 비공개)

각 조합을 prompt template에 끼워 여러 조합을 만들고, trial 2회씩 반복해 안정성을 봤습니다.

Prompt 구조 (요약):

- 핵심 묘사: 변수 축 조합
- 스타일 지침: photorealistic K-pop trainee profile photo
- 구도: chest-up, front-facing

### Step 2 — ID 사진 정제

Step 1 결과에서 발견된 문제 (배경 색감이 인물 식별을 방해, 메이크업 표현 일관성 부족) 를 해결하기 위해 prompt 변종을 비교하고, 정체성을 깨는 요소를 막기 위한 **negative constraints** 를 추가했습니다.

→ 흰 배경 + 메이크업 무관 + 부정 제약으로 **ID 사진의 정체성 일관성** 확보.

### Step 3 — Visual Upgrade

Step 2의 ID 사진을 reference로 두고, 같은 인물성을 유지하면서 **사진 품질을 끌어올리는** prompt 변종을 비교. 채택된 best 버전이 후속 [Content Image Generation](/projects/kpop-virtual-idol-content-generation/) 단계의 기본 reference로 사용됨.

## 대규모 캐스팅 런 (Casting Runs)

Prompt 설계가 어느 정도 안정화된 후, 후보 다양성 확보를 위한 **대규모 반복 생성** — 총 12회 캐스팅 런으로 **약 800장** 생성. 각 런마다 약간씩 다른 prompt seed / 변수 조합 / 모델 파라미터로 결과 분포를 확장하고, 결과를 정성 검수해 **최종 prompt** 를 확정.

## 결과 분석 관점 (정성 요약)

- **prompt 변수 축의 분리도** — 인상·분위기는 잘 구분되지만, **헤어 (특히 색상) 와 메이크업이 서로 영향을 주고받는 경향** 이 있었음 (예: 헤어 색만 바꿨는데 메이크업 톤도 같이 변함). 두 축을 독립적으로 제어하려면 명시적 negative constraint 가 필요.
- **스케일 효과** — 여러 번의 반복 실험을 거쳐 안정적인 후보를 확보. **prompt 설계만으로는 한계가 있고, 양적 탐색이 동반돼야 함.**

## 자동화 파이프라인

각 런은 다음 자동화 위에서 실행:

1. **Prompt template + 변수 격자** — Python으로 모든 조합을 펼침
2. **API 호출**
3. **HTML report 자동 생성** — combo·trial 단위로 시각적으로 비교 가능한 리포트 자동 출력 (정성 검수용)

## Stack

- **Python**
- **Gemini Flash Image Preview**
- **Prompt Engineering** — 5축 변수 정의, system prompt, negative constraints

## 다음 단계 / 관련

- 확정된 companion profile 을 reference로 → [Content Image Generation](/projects/kpop-virtual-idol-content-generation/) (다양한 scene 의 콘텐츠 컷)
- 특정 포즈 정제 → [OPT2I — Iterative Prompt Refinement](/projects/kpop-virtual-idol-opt2i/)
- 챗봇 persona 결합 → [MBTI Persona Priming](/projects/kpop-virtual-idol-mbti/)
