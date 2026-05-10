---
title: "OPT2I — Iterative Prompt Refinement"
date: 2026-04-10
summary: "OPT2I (LLM-as-optimizer) + DSG 평가 metric으로 K-Pop 가상 아이돌 특정 자세 컷 prompt 정제."
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
  - OPT2I (Paper Implementation)
  - DSG (Davidsonian Scene Graph)
  - LLM-as-optimizer
links:
  - type: paper
    url: https://arxiv.org/abs/2403.17804
    label: Reference Paper (OPT2I)
  - type: github
    url: https://github.com/chaeniverse/opt2i-dsg
    label: Implementation
featured: true
status: "Completed"
role: "분석·실험 담당"
duration: "2026.04 진행 중"
highlights:
  - "OPT2I (LLM-as-optimizer) + DSG 평가 metric으로 K-Pop 가상 아이돌 특정 자세 컷 prompt 정제"
---

## 개요

가상 아이돌 캐릭터의 **특정 자세** 컷을 prompt 만으로 안정적으로 생성하기 어려워, **iterative prompt refinement** 알고리즘을 적용한 실험. 베이스 알고리즘은 Mañas et al. (2024) 의 **OPT2I** — LLM을 prompt optimizer로 두고 반복적으로 prompt를 다듬어 vision-language metric을 끌어올리는 방법.

> **보안 안내.** 본 프로젝트는 일부 대외비 작업이 포함되어, 실제 prompt 전문·생성 이미지·캐릭터 식별 정보는 공개하지 않습니다. 본 페이지는 **알고리즘 구조와 실험 설계** 중심으로 정리합니다.

## 1. OPT2I 알고리즘 (요약)

OPT2I는 text-to-image 생성에서 prompt-image alignment 를 끌어올리기 위한 **LLM-as-optimizer 루프**.

```
Input:  user_prompt (초기 prompt)
Output: best_prompt (최적화된 prompt)

for round r = 1..R:
    1. LLM이 현재 best prompt를 변주해 K개의 variant 생성
    2. 각 variant로 이미지 생성 (T2I model)
    3. 각 이미지의 alignment score 측정 (e.g., CLIPScore, ImageReward, DSG)
    4. 가장 높은 점수의 prompt를 다음 round의 seed로 채택
    5. 점수가 더 이상 개선되지 않으면 조기 종료
```

핵심 가정: **LLM이 좋은 prompt 생성기일 뿐 아니라 좋은 prompt 비평가** 도 될 수 있다 → 이전 round의 점수와 prompt 변종 패턴을 LLM context에 넣어 더 나은 변주를 유도.

→ 논문: [Mañas et al., *Improving Text-to-Image Consistency via Automatic Prompt Optimization*, 2024 (arXiv:2403.17804)](https://arxiv.org/abs/2403.17804)

## 2. 구현 — Round × Variant 격자

본 실험에서 사용한 OPT2I 변형 파이프라인:

| 차원 | 표기 | 값 |
|---|---|---|
| Round | `R2 – R5` | 최대 5 라운드 |
| Variant | `V1 – V5` | 라운드 당 후보 변종 수 |

각 round마다 **variant 별 이미지** 를 모두 저장해 사후 정성 검수 + 정량 비교 가능하도록 했습니다.

## 3. 평가 Metric — DSG (Davidsonian Scene Graph)

평가 metric으로 **DSG (Davidsonian Scene Graph)** 를 결합.

- DSG는 prompt를 **scene graph atomic question** 들로 분해하고, VQA 모델로 각 question에 대한 응답 정확도를 평가.
- 단일 score보다 **prompt의 어떤 측면이 충족/실패** 했는지 지시적 (interpretable).

→ `R-V` 격자 결과를 DSG 점수로 비교해, "이 prompt 변주가 얼굴 형태는 잘 맞췄지만 헤어 길이 묘사가 약하다" 같은 진단을 자동화.

## 4. 결과 분석 관점 (정성 요약)

- **DSG 도입 효과** — DSG atomic 평가는 prompt의 어떤 부분이 부족한지 가리켜주어 **다음 round prompt 변주의 방향성** 이 명확해짐.
- **Round 수 trade-off** — round R≥4부터는 점수 상승이 둔화되는 경향. **R=5 cap** 으로도 충분.
- **비용** — round 수 × variant 수 × character 수 만큼 image API 호출이 늘어 비용이 빠르게 증가. 변종 1회당 약 $25–30 수준 (대략 추정).

## Stack

- **Python** — OPT2I 루프 구현, round/variant 격자 관리, 결과 집계
- **Gemini Flash Image Preview**
- **LLM-as-optimizer** — prompt 변주 생성용 LLM (variant 후보 생성)
- **DSG (Davidsonian Scene Graph)** — alignment evaluation metric

## 참고

- Mañas et al., *Improving Text-to-Image Consistency via Automatic Prompt Optimization*, 2024 — [arXiv:2403.17804](https://arxiv.org/abs/2403.17804)
- Cho et al., *Davidsonian Scene Graph: Improving Reliability in Fine-grained Evaluation for Text-to-Image Generation*, ICLR 2024
- Implementation — [`chaeniverse/opt2i-dsg`](https://github.com/chaeniverse/opt2i-dsg) (OPT2I + DSG core + side/fullbody runners)

## 관련

- 트레이니 캐스팅 단계 → [Casting Image Generation](/projects/kpop-virtual-idol-casting-image/)
- 콘텐츠 컷 단계 → [Content Image Generation](/projects/kpop-virtual-idol-content-generation/)
- 챗봇 persona 단계 → [MBTI Persona Priming](/projects/kpop-virtual-idol-mbti/)
