---
title: "Inverse Sampling"
date: 2023-01-11
summary: "분포 f(x)에서 직접 샘플을 뽑기 어려울 때 사용하는 inverse transform sampling. CDF의 역함수 F⁻¹와 균등 분포 U(0,1)을 이용해 임의의 분포를 샘플링하는 방법과 그 기하학적 직관을 정리한다."
tags:
  - Statistics
  - Sampling
  - Monte Carlo
  - Inverse Transform
authors:
  - me
featured: true
---

## Inverse Sampling

분포 $f(x)$ 에서 직접 샘플링하기 어려울 때 쓰는 기법. CDF의 역함수 $F^{-1}$ 과 균등 분포만 있으면 어떤 분포든 (이론적으로는) 뽑을 수 있다.

## 알고리즘

1. $f(x)$ 의 CDF $F(x) = \displaystyle\int_{-\infty}^{x} f(t)\,dt$ 를 구한다.
2. $F$ 의 역함수 $F^{-1}$ 을 구한다.
3. 균등 분포에서 $u \sim \mathrm{Unif}(0,1)$ 을 뽑는다.
4. $x = F^{-1}(u)$ 로 변환하면 $x \sim f(x)$ 이다.

샘플링한 $u$ 들을 $F^{-1}$ 에 넣은 후 히스토그램으로 그리면 $f(x)$ 의 분포에 근사한다.

## 왜 동작하나 (간단 증명)

$U \sim \mathrm{Unif}(0,1)$ 이라 하자. $X = F^{-1}(U)$ 의 CDF를 계산하면

$$P(X \le x) = P(F^{-1}(U) \le x) = P(U \le F(x)) = F(x)$$

마지막 등호는 $U$ 가 $[0,1]$ 균등 분포이기 때문 ($P(U \le t) = t$). 즉 $X$ 의 CDF가 $F$ 와 같으므로 $X \sim f$. $\blacksquare$

## 기하학적 직관

- $f(x)$ 가 한쪽으로 치우친 분포라고 하자 (예: $0$ 근처에 mass가 몰린 감소하는 밀도).
- $F^{-1}$ 은 $u$-축의 균등한 구간을 $x$-축의 **불균등한 구간**으로 매핑한다.
  - $f(x)$ 가 큰 영역 → $F$ 가 가파르게 증가 → $F^{-1}$ 은 완만 → 좁은 $x$ 구간이 넓은 $u$ 구간에 대응
  - $f(x)$ 가 작은 영역 → $F$ 가 느리게 증가 → $F^{-1}$ 은 가파름 → 넓은 $x$ 구간이 좁은 $u$ 구간에 대응
- 따라서 균등 분포 $u$ 를 뽑아 $F^{-1}$ 에 넣으면, **밀도가 높은 $x$ 영역에는 많은 샘플이, 낮은 영역에는 적은 샘플이** 떨어진다.

예: $u$ 를 10개 뽑아 $F^{-1}$ 에 넣으면, 결과 히스토그램이 원본 $f(x)$ 와 닮아간다.

## 한계

- $F^{-1}$ 을 닫힌 형태로 구할 수 있어야 깔끔하게 쓸 수 있다 (지수, 균등, 로지스틱 등).
- 닫힌 형태 $F^{-1}$ 이 없거나 다변량으로 확장하기 어려울 때는 **Rejection sampling**, **MCMC** (Gibbs, Metropolis-Hastings) 등 다른 기법을 쓴다.

---

> 원문: <https://chaeniverse.tistory.com/9>
