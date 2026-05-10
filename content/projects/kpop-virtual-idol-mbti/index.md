---
title: "MBTI Persona Priming prompt research"
date: 2026-05-09
summary: "K-Pop 가상 아이돌 챗봇 persona 일관성을 위한 MBTI 기반 prompt priming 사전조사."
tags:
  - App/Service
  - LLM
  - Prompt Engineering
  - Persona Design
authors:
  - me
tech_stack:
  - Python
  - LLMs
  - Prompt Engineering
links:
  - type: paper
    url: https://arxiv.org/pdf/2509.04343
    label: Reference Paper (arXiv)
  - type: github
    url: https://github.com/spcl/MBTI-in-Thoughts
    label: Reference Code
featured: true
status: "Completed"
role: "분석·설계 담당"
duration: "2026 진행 중"
highlights:
  - "K-Pop 가상 아이돌 챗봇 persona 일관성을 위한 MBTI 기반 prompt priming 사전조사"
---

## 개요

K-Pop 가상 아이돌 앱 프로젝트의 일부로 진행한 **챗봇 persona 사전조사** 입니다. LLM에 일관된 성격을 부여하기 위한 출발점으로, 심리 프로필 priming 방식의 framework — **arXiv 논문 *Psychologically Enhanced AI Agents*** ([https://arxiv.org/pdf/2509.04343](https://arxiv.org/pdf/2509.04343)) 와 그 official 구현 [`spcl/MBTI-in-Thoughts`](https://github.com/spcl/MBTI-in-Thoughts) 를 검토하고, 검증 흐름·prompt 변종 비교를 정리했습니다.

> **보안 안내.** 본 프로젝트는 일부 대외비 작업이 포함되어, 실제 가상 아이돌에 사용될 priming 전문·생성 결과·내부 도식은 공개하지 않습니다. 본 페이지는 적용한 **공개 framework와 실험 설계**를 중심으로 기술합니다.

## 1. Framework

### 1.1 검증 방법 — 사용 모델

검증 단계 LLM: **GPT-4o-mini**

### 1.2 Flow (예: ENFJ)

1. `priming.json` — 16개 MBTI 유형 각각에 대한 priming prompt가 정의돼 있다. 챗봇에 system prompt로 주입한다.
2. 한 유형(예: ENFJ)에 대해 **16Personalities 공식 설문 기반 60문항**을 던진다. 60문항은 E/I, S/N, F/T, J/P 네 축을 결정짓는 항목들로 구성.
3. 각 문항에 대해 동일한 priming + 동일한 질문을 **15회 반복** 한다 (응답 일관성 검증).
   - Temperature = 1.0이라 매번 약간씩 다른 응답이 나올 수 있음.
   - 일관성이 높으면 priming 성공, 낮으면 실패.

### 1.3 Likert 환산

15번 응답을 7점 척도(score)로 환산한다 — 16Personalities 공식 테스트가 7점 척도를 사용하기 때문.

```python
score_dict = {
    "agree":                     -3,
    "generally agree":           -2,
    "partially agree":           -1,
    "neither agree nor disagree": 0,
    "partially disagree":         1,
    "generally disagree":         2,
    "disagree":                   3,
}
```

15회의 score를 평균해 한 문항의 응답값으로 삼고, 60문항에 대해 같은 절차를 수행.

### 1.4 결과 시각화

- 60문항 중 E/I 축을 결정하는 약 10개 문항을 모아 그 sample 평균을 좌표에 찍고 BoxPlot으로 분포를 본다.
- ENFJ로 priming한 LLM이 E축 문항에서 외향적인 응답(예: 평균 −3 근처)을 일관되게 보이는지 검증.

> 결론: **이 priming을 prompt로 썼을 때 LLM이 MBTI 특성을 분명히 구분해 응답한다** 는 가설을 BoxPlot으로 시각적으로 검증.

## 2. Prompt 변종 — 3종 비교

priming 구조의 어느 부분이 효과를 내는지 확인하기 위해 3종의 변종을 비교했다.

### A. Only MBTI

```text
You are an {MBTI_TYPE}.
```

→ MBTI 유형 라벨만 주는 가장 짧은 형태.

### B. MBTI + Description (Structured Priming)

`MBTI 라벨` + 다음 6개 카테고리로 구조화된 description 을 함께 부여한다.

- **Communication Style** (소통 방식)
- **Leadership and Management Style** (리더십)
- **Problem-Solving Approach** (문제 해결)
- **Interpersonal Relationships** (대인 관계)
- **Handling Change and Stress** (스트레스 대처)
- **Application in Various Contexts**

description 은 MBTI 공식 문헌 (*Myers and Myers, 1980, "Gifts Differing"*) 기반으로 LLM 요약을 거쳐 작성.

### C. Only Description

위 6개 카테고리만 두고 **MBTI 라벨은 제거**. 라벨이 priming 효과를 내는지, 설명이 효과를 내는지 분리해 보기 위함.

## 3. 추가 검증 — WritingPrompt 태스크

성격 priming이 **창작 응답**에서도 일관되게 나타나는지 확인하기 위한 별도 검증.

### Flow

1. priming(예: INFJ prompt)을 LLM에 주입.
2. **Reddit r/WritingPrompts** 에서 100개 글쓰기 프롬프트를 LLM에게 제공 → 각 prompt에 대해 짧은 스토리 생성.
   - Story generator: **Qwen3-235B-A22B**
3. 생성된 스토리를 **LLM-as-judge** 가 1–5점으로 평가.
   - Judge: **Qwen2.5-14B-Instruct**
   - 평가 기준: PersonaLLM 등 선행 연구의 persona consistency 지표.

→ 동일한 LLM이 다른 MBTI priming 하에서 글쓰기 스타일이 일관되게 달라지는지를 정량 평가.

## Stack

- **Python** — 실험 파이프라인
- **LLMs** — GPT-4o-mini (검증), Qwen3-235B-A22B (story generation), Qwen2.5-14B-Instruct (judge)
- **Prompt Engineering** — system prompt 설계, priming 구조화, score 환산

## 참고

- *Psychologically Enhanced AI Agents* — [arXiv:2509.04343](https://arxiv.org/pdf/2509.04343)
- Reference code — [`spcl/MBTI-in-Thoughts`](https://github.com/spcl/MBTI-in-Thoughts)
- Myers, I. B., & Myers, P. B. (1980). *Gifts Differing: Understanding Personality Type*.
- 16Personalities 공식 설문 (60문항, 7점 Likert)
