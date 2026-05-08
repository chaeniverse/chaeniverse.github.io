---
title: "Importance Sampling"
date: 2023-01-17
summary: "원래 분포 f(x)에서 샘플링이 어렵거나 비효율적일 때, 다른 분포 φ(x)에서 샘플을 뽑고 가중치 f(x)/φ(x)로 보정해 기댓값을 계산하는 기법. Monte Carlo 기본형부터 importance sampling까지 정리."
tags:
  - Statistics
  - Sampling
  - Monte Carlo
  - Importance Sampling
authors:
  - me
featured: true
---

## Monte Carlo

기댓값을 계산하는 방법. $X \sim f(x)$ 일 때 $g(X)$ 의 기댓값은 다음 세 가지 형태로 동치다.

$$\underbrace{E[g(X)]}_{\text{①}} \;=\; \underbrace{\int g(x) f(x)\,dx}_{\text{②}} \;\approx\; \underbrace{\frac{1}{n}\sum_{i=1}^{n} g(x_i)}_{\text{③}}$$

①, ②는 정의상 같고, ③은 $f$ 에서 뽑은 샘플 $\{x_i\}$ 의 평균으로 ②를 근사한 것 (대수의 법칙).

### 예제 1: 단순 MC

$g(x) = e^{-2x}$, $X \sim \mathrm{Unif}(0,1)$ 일 때 $E[g(X)]$ 을 구하라.

이때 $f(x) = 1$ (Unif(0,1) 의 밀도)이므로

$$E[g(X)] = \int_0^1 e^{-2x}\,dx \;\approx\; \frac{1}{N}\sum_{i=1}^{N} e^{-2 x_i}, \qquad x_i \sim \mathrm{Unif}(0,1)$$

균등 분포에서 $N$ 개를 뽑아 $g$ 에 넣고 평균을 내면 끝.

## Importance Sampling

문제는 다음 두 경우다.

1. **$f(x)$ 에서 샘플링이 어렵다.** 닫힌 형태로 sampling이 안 되는 분포.
2. **$g(x) \cdot f(x)$ 가 $f$ 의 꼬리/희소 영역에 몰려 있다.** $f$ 에서 뽑은 대부분의 샘플이 $g \cdot f$ 가 큰 영역을 못 맞춰서 분산이 매우 커진다.

이럴 때는 다른 분포 $\phi(x)$ ("proposal" 또는 "importance distribution")에서 샘플을 뽑고 가중치로 보정한다. 핵심 항등식:

$$E_f[g(X)] = \int g(x) f(x)\,dx = \int g(x) \cdot \frac{f(x)}{\phi(x)} \cdot \phi(x)\,dx = E_\phi\!\left[g(X) \cdot \frac{f(X)}{\phi(X)}\right]$$

→ $\phi$ 에서 샘플 $\{x_i\}$ 을 뽑고

$$E_f[g(X)] \;\approx\; \frac{1}{N}\sum_{i=1}^{N} g(x_i) \cdot \underbrace{\frac{f(x_i)}{\phi(x_i)}}_{\text{weight}}$$

여기서 $f(x)/\phi(x)$ 가 **importance weight**. (이 가중치 때문에 "importance" sampling이라는 이름이 붙은 것)

## 예제 2: $\int (x-1)(x-2)\,dx$

이 식은 따로 정해진 $f(x)$ 가 없다 (단순 적분). $\phi(x) \sim \mathrm{Exp}(1)$, 즉 $\phi(x) = e^{-x}$ ($x>0$) 를 proposal로 쓰자.

$$\int (x-1)(x-2)\,dx = \int \underbrace{\frac{(x-1)(x-2)}{e^{-x}}}_{\text{new } g(x)} \cdot \underbrace{e^{-x}}_{\text{new } f(x)}\,dx$$

→ $X \sim \mathrm{Exp}(1)$ 에서 $N$ 개를 뽑아 새 $g$ 에 넣고 평균:

$$\widehat{E[g(X)]} = \frac{1}{N}\sum_{i=1}^{N} \frac{(x_i-1)(x_i-2)}{e^{-x_i}}, \qquad x_i \sim \mathrm{Exp}(1)$$

## 예제 3: $\int e^{-|x|}\,dx$ with $N(0,1)$ proposal

$\phi(x) \sim N(0,1)$, 즉 $\phi(x) = \dfrac{1}{\sqrt{2\pi}} e^{-x^2/2}$ 를 쓰자.

$$\int e^{-|x|}\,dx = \int \underbrace{\frac{e^{-|x|}}{\frac{1}{\sqrt{2\pi}} e^{-x^2/2}}}_{\text{new } g(x)} \cdot \underbrace{\frac{1}{\sqrt{2\pi}} e^{-x^2/2}}_{\text{new } f(x)}\,dx$$

→ $X \sim N(0,1)$ 에서 $N$ 개 sampling 후 새 $g$ 에 넣어 평균을 구하면 된다.

## 왜 $N(0,1)$ 을 proposal로 골랐나

원래의 $g(x) = e^{-|x|}$ 는 0 근처에 봉우리가 있는 양옆 대칭 함수다. $\phi(x) \sim N(0,1)$ 도 비슷한 모양 — 0 근처에 봉우리, 양쪽으로 빠르게 감소.

> **proposal $\phi(x)$ 를 $|g(x) f(x)|$ 와 모양이 비슷하게 잡으면 분산이 작아져 효율이 좋다.**

만약 $\phi$ 가 $|g \cdot f|$ 가 큰 영역을 거의 안 덮으면, 거의 모든 샘플의 weight $f(x)/\phi(x)$ 가 0 근처가 되고, 가끔 한 샘플의 weight가 매우 커져서 추정량의 분산이 폭발한다.

## 한 줄 요약

> **샘플링은 $\phi$ 에서, 평균은 weight $f/\phi$ 로 보정.**
>
> Proposal $\phi$ 의 모양을 신경써서 고를수록 추정량의 분산이 작아진다.

---

> 원문: <https://chaeniverse.tistory.com/11>
