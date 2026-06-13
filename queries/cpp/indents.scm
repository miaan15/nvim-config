;; inherits: c
;; extends

;; Indent blocks, namespaces, and classes
[
  (compound_statement)
  (namespace_definition)
  (field_declaration_list)
] @indent.begin

;; De-indent closing braces
] @indent.end
