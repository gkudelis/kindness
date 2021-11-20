(local kind-methods {}) ; methods shared by all kinds

(fn kind-methods.method [self name function]
  (let [kind-metatable (getmetatable self)
        value-methods (. kind-metatable :value-metatable :__index)]
    (tset value-methods name function)))

(fn kind []
  (local value-methods {}) ; methods shared by all values of a kind
  (local value-metatable {:__index value-methods})
  (local kind-metatable {:__index kind-methods :value-metatable value-metatable})

  (fn init [] (doto {} (setmetatable value-metatable)))

  (doto {: init} (setmetatable kind-metatable)))

;(fn trait [] {})

{: kind}
; : trait}
