#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: vardict
label: vardict
requirements:
    MultipleInputFeatureRequirement: {}
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    StepInputExpressionRequirement: {}
inputs:
  bedfile:
    type: File?
  b2:
    type: File?
    secondaryFiles: ['.bai']
  b:
    type: File?
    secondaryFiles: ['.bai']
  C:
    type: boolean?
  D:
    type: boolean?
  N:
    type: string?
  N2:
    type: string?
  x:
    type: string?
  z:
    type: string?
  th:
    type: string?
  M:
    type: string?
  I:
    type: string?
  H:
    type: boolean?
  F:
    type: string?
  E:
    type: string?
  T:
    type: string?
  m:
    type: string?
  k:
    type: string?
  i:
    type: boolean?
  hh:
    type: boolean?
  g:
    type: string?
  f:
    type: string?
  e:
    type: string?
  d:
    type: string?
  c:
    type: string?
  a:
    type: string?
  O:
    type: string?
  P:
    type: string?
  Q:
    type: string?
  R:
    type: string?
  V:
    type: string?
  VS:
    type: string?
  X:
    type: string?
  Z:
    type: string?
  B:
    type: int?
  S:
    type: string?
  n:
    type: string?
  o:
    type: string?
  p:
    type: boolean?
  q:
    type: string?
  r:
    type: string?
  t:
    type: boolean?
  vcf:
    type: string?
  G:
    type: File
    secondaryFiles: ['.fai']
  f_1:
    type: string?
outputs:
  output:
    type: File
    outputSource: vardict/output
steps:
  vardict:
    run: ./vardict_core.cwl
    in:
      B: B
      C: C
      D: D
      E: E
      F: F
      G: G
      H: H
      I: I
      M: M
      N: N
      O: O
      P: P
      Q: Q
      R: R
      S: S
      T: T
      V: V
      VS: VS
      X: X
      Z: Z
      a: a
      b: b
      b2: b2
      bedfile: bedfile
      c: c
      d: d
      e: e
      f: f
      g: g
      h: hh
      i: i
      k: k
      m: m
      n: n
      o: o
      p: p
      q: q
      r: r
      t: t
      th: th
      vcf: vcf
      v:
        valueFrom: ${ return inputs.vcf.replace(".vcf", "_tmp.vcf") }
      x: x
      z: z
    scatter: [bedfile]
    scatterMethod: dotproduct
    out: [output]