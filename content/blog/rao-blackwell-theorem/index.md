---
title: "Rao–Blackwell Theorem"
date: 2022-10-31
summary: "충분통계량 S에 대해 비편향추정량 T를 조건부 기댓값 f(S) = E(T|S)로 바꾸면 분산이 감소한다는 정리. 정의와 전분산 분해 기반 증명을 정리한다."
tags:
  - Statistics
  - Estimation Theory
  - Sufficient Statistics
  - MVUE
authors:
  - me
featured: true
---

## Rao–Blackwell Theorem

$g(\theta)$ 를 모수의 함수, 그리고

- $S$ : sufficient statistic
- $T$ : $g(\theta)$ 의 unbiased estimator (u.e.)

라 하자. 이때

$$f(S) \;=\; E(T(X) \mid S) \;=\; E(T \mid S)$$

는 $g(\theta)$ 에 의존하지 않는 **통계량**이며, $f(S)$ 도 역시 $g(\theta)$ 의 비편향추정량이다.

(여기서 $f(S)$ 의 정의가 $\theta$ 에 의존하지 않는다 — $S$ 가 sufficient이기 때문에 $T \mid S$ 의 분포가 $\theta$ 와 무관해서, 조건부 기댓값도 $\theta$ 와 무관하다.)

또한 모든 $\theta$ 에 대하여 다음이 성립한다.

$$\mathrm{Var}(f(S)) \;\le\; \mathrm{Var}(T(X)) \tag{1}$$

따라서 $f(S)$ 는 **MVUE 가 될 후보**가 된다.

이제 (1)을 증명하자.

## 증명

먼저 $f(S)$ 가 비편향임을 확인:

$$E(f(S)) = E\big(E(T(X) \mid S)\big) = E(T(X)) = g(\theta) \quad \text{(이중기댓값 정리)}$$

이제 $\mathrm{Var}(T(X))$ 를 전개한다. $E(f(S)) = g(\theta)$ 이고 $E(T(X)) = g(\theta)$ 이므로

$$\mathrm{Var}(T(X)) = E\big[T(X) - E(f(S))\big]^2$$

$T(X)$ 와 $E(f(S))$ 사이에 $f(S)$ 를 더하고 빼서 분리한다 ($+f(S) - f(S)$):

$$= E\big[(T(X) - f(S)) + (f(S) - E(f(S)))\big]^2$$

제곱을 전개하면

$$= \underbrace{E\big[T(X) - f(S)\big]^2}_{\text{(I)}} \;+\; 2\underbrace{E\big[(T(X) - f(S))(f(S) - E(f(S)))\big]}_{(\star)} \;+\; \underbrace{E\big[f(S) - E(f(S))\big]^2}_{=\,\mathrm{Var}(f(S))}$$

### 핵심: 교차항 $(\star) = 0$

$$(\star) = E\big[(T(X) - f(S))(f(S) - E(f(S)))\big]
       = E\Big[\,E\big[(T(X) - f(S))(f(S) - E(f(S))) \,\big|\, S\big]\,\Big]$$

조건부 안에서 $f(S)$ 와 $E(f(S))$ 는 $S$ 에 대해 상수처럼 다룰 수 있으므로 (전자는 $S$ 의 함수, 후자는 그냥 상수)

$$= E\Big[\,(f(S) - E(f(S))) \cdot E\big[T(X) - f(S) \,\big|\, S\big]\,\Big]$$

내부 조건부 기댓값을 분리하면

$$E\big[T(X) - f(S) \,\big|\, S\big] = E(T(X) \mid S) - E(f(S) \mid S) = f(S) - f(S) = 0$$

(첫 항은 $f(S)$ 의 정의 자체이고, 둘째 항은 $f(S)$ 가 $S$ 의 함수라 $E(f(S) \mid S) = f(S)$.)

따라서 $(\star) = 0$.

### 결론

$$\mathrm{Var}(T(X)) = E[T(X) - f(S)]^2 + \mathrm{Var}(f(S)) \;\ge\; \mathrm{Var}(f(S))$$

$E[T(X) - f(S)]^2 \ge 0$ 이므로

$$\mathrm{Var}(f(S)) \le \mathrm{Var}(T(X)) \qquad \blacksquare$$

## 한 줄 요약

> **충분통계량으로 조건부 기댓값을 취하면, 비편향성을 유지하면서 분산이 감소한다.**

이 때문에 MVUE를 찾을 때는 어떤 비편향추정량을 가지고 시작하든 sufficient statistic으로 Rao–Blackwell화 (Rao–Blackwellize)하는 것이 유리하다. 단, 이렇게 얻은 $f(S)$ 가 **유일한 MVUE**라고 결론지으려면 $S$ 의 **완비성 (completeness)** 이 추가로 필요하며, 이것이 Lehmann–Scheffé 정리로 이어진다.

---

> 원문: <https://chaeniverse.tistory.com/3>
