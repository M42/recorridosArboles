module Trees where 
  open import Data.List
  open import Data.Nat
  open import Relation.Binary.PropositionalEquality hiding ([_])
  open import Function using (_∘_; _$_)
  


  -- Tree definition
  data Tree (A : Set) : Set where
    Nil : Tree A
    Node : A → Tree A → Tree A → Tree A

  reflect : {A : Set} → Tree A → Tree A
  reflect Nil = Nil
  reflect (Node a lt rt) = Node a (reflect rt) (reflect lt)

  -- List inverse
  inv : {A : Set} → List A → List A
  inv [] = []
  inv (x ∷ xs) = (inv xs) ++ [ x ]

  -- Traversals of a tree
  tpreorder : {A : Set} → Tree A → List A
  tpreorder Nil = []
  tpreorder (Node a lt rt) = a ∷ (tpreorder lt) ++ (tpreorder rt)

  tinorder : {A : Set} → Tree A → List A
  tinorder Nil = []
  tinorder (Node a lt rt) = (tinorder lt) ++ [ a ] ++ (tinorder rt)

  tposorder : {A : Set} → Tree A → List A
  tposorder Nil = []
  tposorder (Node a lt rt) = (tposorder lt) ++ (tinorder rt) ++ [ a ]



  -- Auxiliary lemmas
  -- Reflection lemma
  rflinvolutive : {A : Set} → (t : Tree A) → (t ≡ reflect (reflect t))
  rflinvolutive Nil = refl
  rflinvolutive (Node a lt rt) = cong₂ (λ l r → Node a l r) (rflinvolutive lt) (rflinvolutive rt)

  -- Involutive inversion lemmas
  invunit : {A : Set} → (l : List A) → (a : A) → (inv (l ++ [ a ])) ≡ a ∷ (inv l)
  invunit [] a = refl
  invunit (x ∷ xs) a = cong (λ l → l ++ [ x ]) (invunit xs a)

  invinvolutive : {A : Set} → (l : List A) → (inv (inv l)) ≡ l
  invinvolutive [] = refl
  invinvolutive (x ∷ xs) = trans (invunit (inv xs) x) $ cong (λ t → x ∷ t) (invinvolutive xs)

  invunit₁ : {A : Set} → (l : List A) → (a : A) → l ++ [ a ] ≡ inv (a ∷ (inv l))
  invunit₁ l a = trans (sym (invinvolutive (l ++ [ a ]))) (cong inv (invunit l a))
  invunit₂ : {A : Set} → (l : List A) → (a : A) → inv l ++ [ a ] ≡ inv (a ∷ l)
  invunit₂ l a = trans (invunit₁ (inv l) a) (cong (λ r → inv (a ∷ r)) (invinvolutive l))
  
  -- Two list lemmas
  plusempty : {A : Set} → (l : List A) → l ++ [] ≡ l
  plusempty [] = refl
  plusempty (x ∷ xs) = cong (λ l → x ∷ l) (plusempty xs)

  plusassoc : {A : Set} → (l p q : List A) → l ++ (p ++ q) ≡ (l ++ p) ++ q
  plusassoc [] p q = refl
  plusassoc (a ∷ l) p q = cong (_∷_ a) (plusassoc l p q)

  -- Inversion distributes
  invdist : {A : Set} → (p q : List A) → inv (p ++ q) ≡ inv q ++ inv p
  invdist [] qs = sym (plusempty (inv qs))
  invdist (p ∷ ps) qs = trans (trans (sym (invunit₂ (ps ++ qs) p)) (trans (cong (λ x → x ++ [ p ]) (invdist ps qs)) (sym (plusassoc (inv qs) (inv ps) [ p ])))) (cong (λ l → inv qs ++ l) (invunit₂ ps p))


  -- Theorems
  -- Preorder of a reflected tree
  prerfl : {A : Set} → (t : Tree A) → (tpreorder (reflect t)) ≡ (inv (tposorder t))
  prerfl Nil = refl
  prerfl (Node a lt rt) = {!!}

  