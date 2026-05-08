---
title: "MLP (Multi-Layer Perceptron)"
date: 2024-09-21
summary: "단일 perceptron의 한계를 극복하기 위해 여러 perceptron을 결합한 MLP. Hidden node의 역할, XOR 문제 해결, 그리고 backpropagation까지."
tags:
  - Machine Learning
  - Deep Learning
  - Neural Network
  - MLP
authors:
  - me
featured: true
---

## Perceptron의 한계

단일 perceptron은 두 클래스를 분리하는 hyperplane을 만드는 **선형 모델**. 변수 관계가 비선형이면 잡아내지 못한다 — 곡선 패턴이 더 적합한 복잡한 관계를 선형 회귀가 잡을 수 없는 것과 같은 한계.

## MLP 도입

핵심 원리: **여러 선을 결합해 복잡한 문제를 작은 부분 문제들로 분해**한다. 서로 다른 영역을 식별하는 여러 perceptron을 만들고 그 출력을 조합 → 비선형 결정 경계 형성.

여러 hidden layer를 쌓으면 모델 복잡도가 증가하고 — 이게 바로 **딥러닝 아키텍처의 시작**.

## Decision Boundary 비교

| 모델 | 결정 경계 |
|---|---|
| Logistic regression | 선 1개, 임의 방향 |
| Decision tree | 축에 수직인 여러 선 |
| **MLP** | **선 개수와 방향 모두 자유롭게 조정 가능** (hidden layer / node 수로 복잡도 제어) |

## 기본 구조

각 input은 모든 hidden node에 서로 다른 가중치로 연결됨. Hidden node가 정보를 처리해 output node에서 집계.

분류의 경우 output node 수 = 클래스 수. **One-hot encoding** + **softmax** 로 확률 분포 출력:

$$y_j = \frac{e^{z_j}}{\sum_{k=1}^{c} e^{z_k}}$$

## Hidden Node의 역할

Hidden node 수 = **네트워크의 복잡도**. 노드가 많을수록 더 정교한 결정 경계가 가능.

## XOR 문제 다시 보기

선형 분리가 불가능한 데이터를 hidden node를 통해 **분리 가능한 공간으로 변환**한다. 중간 단계에서 선형 분리들을 만들고 결합하면, 원래는 분리 불가능했던 데이터셋도 분류 가능해진다.

## Error Back-Propagation

Gradient descent + backpropagation으로 가중치 업데이트.

- **Output → Hidden 가중치**: 실제값과 예측값의 차이 × hidden node 값에 비례해 조정
- **Input → Hidden 가중치**: 오차 크기와 input 값에 의존

## 학습 종료 / 기타

학습은 다음 조건에서 종료:

- 가중치 변화가 미미함
- Validation 오차가 임계값 아래로 떨어짐
- 미리 정한 epoch 수 도달

Overfitting 방지를 위한 메커니즘들이 존재 (dropout, regularization, early stopping 등).

---

> 원문: <https://chaeniverse.tistory.com/79>
