---
title: "XGBoost"
date: 2024-09-21
summary: "Gradient Boosting을 빠르고 확장 가능하게 만든 XGBoost. 근사 split finding, sparsity-aware split, 그리고 시스템 설계 (column-wise pre-sorted) 까지."
tags:
  - Machine Learning
  - Ensemble
  - Boosting
  - XGBoost
authors:
  - me
featured: true
---

## 발전 흐름

단일 decision tree → bagging / Random Forest → Gradient Boosting → **XGBoost**

XGBoost는 gradient boosting machine의 **성능, 확장성, 속도** 를 최적화한 구현. 핵심은 **정확한 계산 대신 빠른 근사 해**를 도입했다는 점.

## Split Finding Algorithm

Decision tree가 분기점을 찾을 때 가장 큰 비용은 "어느 변수의 어느 값에서 split할지" 결정하는 것.

### Exact Greedy

모든 가능한 split 후보를 다 시험. 정렬을 포함해 $O(n \log n)$ 의 복잡도. 데이터가 크면 매우 느리다.

### Approximation 방식

XGBoost는 변수 값들을 **percentile 기반 bucket** 으로 나눈 뒤, 각 bucket 안에서만 후보 split을 탐색한다. 예시에서 39개 후보를 30개로 줄이면서 동시에 **bucket 단위로 멀티스레드 병렬화** 가능.

두 가지 변종:

- **Global variant** — tree depth 전반에 걸쳐 동일한 bucket 구조를 유지
- **Local variant** — 노드마다 일정한 bucket 개수를 유지 (depth가 깊어질수록 더 세밀)

성능 비교: 근사 알고리즘은 exact 방식과 **거의 동등한 정확도**를 훨씬 짧은 계산 시간으로 달성.

## Sparsity-Aware Split Finding

결측값 처리에 특화. 학습 시 결측값을 split의 **왼쪽 / 오른쪽으로 보내는 두 옵션을 모두 시험**해보고, split 성능이 더 좋은 방향을 그 노드의 default direction으로 학습한다.

→ 결측 패턴이 있는 데이터에서 별도의 imputation 없이도 우수한 성능.

## System Design

데이터를 **column-wise** 포맷으로 저장하고 사전에 정렬해 둔다. tree 학습 중 같은 정렬을 반복할 필요 없음 → 메모리 오버헤드 감소, 속도 향상.

또한 cache-aware access, out-of-core computation, sparse-aware computation 등 시스템 레벨 최적화가 결합되어, 대규모 데이터에서도 실용적인 학습 시간을 보장한다.

---

> 원문: <https://chaeniverse.tistory.com/78>
