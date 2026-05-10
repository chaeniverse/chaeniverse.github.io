---
title: "LLM Model Benchmark"
date: 2026-01-30
summary: "K-Pop 가상 아이돌 챗봇에 쓸 LLM을 고르기 위한 모델 벤치마크."
tags:
  - App/Service
  - LLM
  - Benchmarking
  - Prompt Engineering
authors:
  - me
tech_stack:
  - Python
  - LLM
  - EQ-Bench
links:
  - type: paper
    url: https://arxiv.org/pdf/2312.06281
    label: Reference Paper (EQ-Bench)
  - type: github
    url: https://github.com/EQ-bench/eqbench3
    label: Reference Code
  - type: github
    url: https://github.com/chaeniverse/LLM-bench
    label: Implementation
featured: true
status: "Completed"
role: "분석·실험 담당"
duration: "2026.01 진행 중"
highlights:
  - "K-Pop 가상 아이돌 챗봇에 쓸 LLM을 고르기 위한 모델 벤치마크"
---

## 개요

K-Pop 가상 아이돌 앱 프로젝트의 일부로 진행한 **LLM 모델 비교 / 선정** 단계. 챗봇 응답 품질·비용·지연시간을 동시에 만족하는 모델을 찾기 위해 다수의 후보 (GPT, Claude, Gemini, Kimi, Qwen 계열) 를 동일한 조건으로 벤치마크했습니다.

> **보안 안내.** 본 프로젝트는 일부 대외비 작업이 포함되어, 실제 벤치마크 질문 전문·모델 응답·내부 시스템 prompt는 공개하지 않습니다. 본 페이지는 **평가 기준 전환과 모델 선정 프레임워크** 중심으로 정리합니다.

## 1. 평가 방법 — EQ-Bench

> [Paech, EQ-Bench: An Emotional Intelligence Benchmark for Large Language Models, 2024 (arXiv:2312.06281)](https://arxiv.org/pdf/2312.06281)

LLM의 **감정 이해 능력** 을 측정하는 벤치마크. 우리 task에 직접 부합.

#### 방법론 (요약)

1. 감정적으로 복잡한 대화 한 토막을 LLM에게 보여준다.
2. 그 대화 속 한 캐릭터의 감정 강도를 4가지 감정으로 LLM이 예측 (각 0–10).
3. 4 점수의 합이 10이 되도록 normalize.
4. **Reference (저자 주석값)** 와의 차이를 계산 — 차이가 작을수록 잘 맞춘 것.
5. 한 문제 점수 = `10 - 차이의 절댓값 합`.
6. 60개 문제의 평균 × 10 → **EQ-Bench 점수 (0–100 스케일)**.

감정 4개는 **명백히 틀린 것 + 명백히 맞는 것 + 미묘한 것** 을 섞도록 큐레이션.

→ Public leaderboard: <https://eqbench.com/>

## 2. 모델 풀 + 경량 모델 체크리스트

EQ-Bench 리더보드 상위권 50+ 모델을 일단 풀로 두고, 그 중 **서비스 비용으로 운영 가능한 경량 모델** 을 체크리스트로 골라냈습니다.

### 풀 (예시)

- **프리미엄 / 대형**: Kimi-K2-Instruct, GPT-5.2, o3, Gemini-3-pro-preview, GPT-5.1, Claude-Opus-4.5, Hermes-4-405B, Llama-3.1-405B-Instruct, …
- **중형**: Claude-Sonnet-4.5, GLM-4.7, GPT-4.1, Mistral-Large, …
- **경량 (서비스용 후보)**: GPT-4.1-mini, Gemini-2.5-flash-preview, o4-mini, GPT-4.1-nano, Qwen3-8B, Mistral-Small-3.x, Llama-4-Scout/Maverick, Gemma-3-4b/27b, GPT-OSS-20b, …

→ 총 약 **24개의 경량 모델** 을 후보로 추렸음.

## 3. 서비스용 추천 Top 5 (× 2 카테고리)

### 프리미엄 Top 5

| 순위 | 모델 | 추천 이유 |
|---|---|---|
| 1 | Kimi-K2-Instruct | 1T 파라미터 (32B 활성 MoE), 가성비 매우 좋음 |
| 2 | GPT-5.2 | 프리미엄 안정성 |
| 3 | o3 | 프리미엄 reasoning |
| 4 | Gemini-3-pro-preview | 프리미엄 |
| 5 | Claude-Opus-4.5 | 프리미엄 |

### 경량 Top 5

| 순위 | 모델 | 추천 이유 |
|---|---|---|
| 1 | GPT-4.1-mini | 가성비 최고, 안정적 |
| 2 | Gemini-2.5-flash-preview | 빠름, 무료 티어 |
| 3 | o4-mini | 경량 reasoning |
| 4 | GPT-4.1-nano | 초저가 |
| 5 | Qwen3-8B | 오픈소스, 로컬 가능 |

## 4. 비용 비교 프레임워크

벤치마크 한 건당 토큰 사용량을 기준으로 **모델별 단가** 를 계산:

- **Input**: ~900 tokens (system prompt + user message)
- **Output**: ~100 tokens (1–2문장 응답)

### 프리미엄 (1건당 비용 / 10건 기준)

| 모델 | 1건 | 10건 | 대비 |
|---|---|---|---|
| Kimi-K2-Instruct | $0.00079 | $0.0079 | **1×** |
| GPT-5.2 | $0.00298 | $0.0298 | 3.8× |
| o3 | $0.00260 | $0.0260 | 3.3× |
| Gemini-3-pro-preview | $0.00300 | $0.0300 | 3.8× |
| Claude-Opus-4.5 | $0.00700 | $0.0700 | 8.9× |

### 경량 (1건당 비용 / 10건 기준)

| 모델 | 1건 | 10건 | 대비 |
|---|---|---|---|
| Qwen3-8B | $0.000070 | $0.0007 | **1×** |
| GPT-4.1-nano | $0.000130 | $0.0013 | 1.9× |
| Gemini-2.5-flash-preview | $0.000520 | $0.0052 | 7.4× |
| GPT-4.1-mini | $0.000520 | $0.0052 | 7.4× |
| o4-mini | $0.001430 | $0.0143 | 20.4× |

### 가격 형성 배경 (예시)

**Kimi-K2 가 저렴한 이유**:

- 중국 기업 (Moonshot AI) 의 시장 점유 전략 — 공격적 가격
- MoE 아키텍처 (1T 파라미터 중 32B 활성) → 추론 비용 절감
- DeepSeek 등 중국 모델들과의 가격 경쟁
- 중국 내 GPU/서버 비용이 상대적으로 저렴

→ DeepSeek R1, Kimi 등이 **경쟁사 대비 약 90% 저렴한 가격** 으로 시장 진입.

## 5. 벤치마크 실험 — 통제 조건

| 조건 | 값 |
|---|---|
| Temperature | 0.7 (다양성 ↔ 안정성 절충) |
| System prompt | MBTI description + "[중요] 1–2문장으로 간결하게 답변하세요." |
| 벤치마크 질문 | 우리 도메인에 맞춰 큐레이션한 3개 |

각 모델 × MBTI × question 조합으로 응답을 수집하고, 응답 길이·지연시간·비용·정성 품질을 같이 적재.

실서비스 도입 전 **정성 검수 + 비용 시뮬레이션** 을 진행했습니다.

## 6. 의사결정 영향

본 벤치마크 결과는 후속 단계 모델 선택의 **베이스라인** 으로 활용됩니다.

## Stack

- **Python** — 벤치마크 파이프라인 (모델 호출)
- **LLMs**
- **EQ-Bench** — 감정 이해 평가 framework

## 참고

- Paech, *EQ-Bench: An Emotional Intelligence Benchmark for Large Language Models*, 2024 — [arXiv:2312.06281](https://arxiv.org/pdf/2312.06281)
- Reference code — [`EQ-bench/eqbench3`](https://github.com/EQ-bench/eqbench3)
- Implementation — [`chaeniverse/LLM-bench`](https://github.com/chaeniverse/LLM-bench) (벤치마크 노트북)
- Public leaderboard — <https://eqbench.com/>
