; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -O0 -global-isel -stop-after=irtranslator -o - %s | FileCheck %s

%type = type [4 x {i8, i32}]

define i8*  @translate_element_size1(i64 %arg) {
; CHECK-LABEL: name: translate_element_size1
; CHECK: [[OFFSET:%[0-9]+]]:_(s64) = COPY $x0
; CHECK: [[BASE:%[0-9]+]]:_(p0) = G_CONSTANT i64 0
; CHECK: [[GEP:%[0-9]+]]:_(p0) = G_GEP [[BASE]], [[OFFSET]]
  %tmp = getelementptr i8, i8* null, i64 %arg
  ret i8* %tmp
}

define %type* @first_offset_const(%type* %addr) {

  ; CHECK-LABEL: name: first_offset_const
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 32
  ; CHECK:   [[GEP:%[0-9]+]]:_(p0) = G_GEP [[COPY]], [[C]](s64)
  ; CHECK:   $x0 = COPY [[GEP]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %res = getelementptr %type, %type* %addr, i32 1
  ret %type* %res
}

define %type* @first_offset_trivial(%type* %addr) {

  ; CHECK-LABEL: name: first_offset_trivial
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(p0) = COPY [[COPY]](p0)
  ; CHECK:   $x0 = COPY [[COPY1]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %res = getelementptr %type, %type* %addr, i32 0
  ret %type* %res
}

define %type* @first_offset_variable(%type* %addr, i64 %idx) {

  ; CHECK-LABEL: name: first_offset_variable
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0, $x1
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x1
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 32
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[C]], [[COPY1]]
  ; CHECK:   [[GEP:%[0-9]+]]:_(p0) = G_GEP [[COPY]], [[MUL]](s64)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[GEP]](p0)
  ; CHECK:   $x0 = COPY [[COPY2]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %res = getelementptr %type, %type* %addr, i64 %idx
  ret %type* %res
}

define %type* @first_offset_ext(%type* %addr, i32 %idx) {

  ; CHECK-LABEL: name: first_offset_ext
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w1, $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 32
  ; CHECK:   [[SEXT:%[0-9]+]]:_(s64) = G_SEXT [[COPY1]](s32)
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[C]], [[SEXT]]
  ; CHECK:   [[GEP:%[0-9]+]]:_(p0) = G_GEP [[COPY]], [[MUL]](s64)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[GEP]](p0)
  ; CHECK:   $x0 = COPY [[COPY2]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %res = getelementptr %type, %type* %addr, i32 %idx
  ret %type* %res
}

%type1 = type [4 x [4 x i32]]
define i32* @const_then_var(%type1* %addr, i64 %idx) {

  ; CHECK-LABEL: name: const_then_var
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0, $x1
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x1
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 272
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK:   [[GEP:%[0-9]+]]:_(p0) = G_GEP [[COPY]], [[C]](s64)
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[C1]], [[COPY1]]
  ; CHECK:   [[GEP1:%[0-9]+]]:_(p0) = G_GEP [[GEP]], [[MUL]](s64)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(p0) = COPY [[GEP1]](p0)
  ; CHECK:   $x0 = COPY [[COPY2]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %res = getelementptr %type1, %type1* %addr, i32 4, i32 1, i64 %idx
  ret i32* %res
}

define i32* @var_then_const(%type1* %addr, i64 %idx) {

  ; CHECK-LABEL: name: var_then_const
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0, $x1
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x1
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 64
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 40
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[C]], [[COPY1]]
  ; CHECK:   [[GEP:%[0-9]+]]:_(p0) = G_GEP [[COPY]], [[MUL]](s64)
  ; CHECK:   [[GEP1:%[0-9]+]]:_(p0) = G_GEP [[GEP]], [[C1]](s64)
  ; CHECK:   $x0 = COPY [[GEP1]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %res = getelementptr %type1, %type1* %addr, i64 %idx, i32 2, i32 2
  ret i32* %res
}
