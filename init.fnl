(local kind-methods {}) ; methods shared by all kinds

(fn kind-methods.constructor [self name cf]
  (let [kind-metatable (getmetatable self)
        value-metatable (. kind-metatable :value-metatable)]
    (tset self name (fn [...] (setmetatable (cf ...) value-metatable)))))

(fn kind-methods.method [self name function]
  (let [kind-metatable (getmetatable self)
        value-methods (. kind-metatable :value-metatable :__index)]
    (tset value-methods name function)))

(fn kind-methods.variants [self ...]
  (let [kind-metatable (getmetatable self)
        value-metatable (. kind-metatable :value-metatable)
        variants {...}]
    (each [name cf (pairs variants)]
      (tset self name (fn [...] (setmetatable {name (cf ...)} value-metatable))))
    (self:method :vary (fn [self ...]
                         (var found-match false)
                         (each [name f (pairs {...}) :until found-match]
                           (when (. variants name)
                             (set found-match true)
                             (f (. self name))))))))

(fn kind [name]
  (local k {: name})

  (local value-methods {:kind #k}) ; methods shared by all values of a kind
  (local value-metatable {:__index value-methods})
  (local kind-metatable {:__index kind-methods :value-metatable value-metatable})

  (setmetatable k kind-metatable))

;(fn trait [] {})

{: kind}
; : trait}
