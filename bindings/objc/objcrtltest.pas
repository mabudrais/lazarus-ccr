{
 Objective-C rtl Test application. by dmitry boyarintsev s2009

 Should compile and run with no problems
 program output should look like:

 Objective-C runtime initialized successfuly
 -init method
 called newMethod1
 called newMethod2, a = 5; b = 4
 get double =  1.33300000000000E+000
 get float  =  3.12500000000000E+000
 test successfully complete
}

program objcrtltest;

{$mode objfpc}{$H+}

uses
  objcrtl20, objcrtl10, objcrtl, objcrtlutils;

{.$linkframework AppKit}
{.$linkframework Foundation}

type
  PSmallRecord = ^TSmallRecord;
  TSmallRecord = packed record
    a,b,c: byte;
    //d : Integer;
    d: byte;
  end;

const
  newClassName   = 'NSMyObject';
  overrideMethod = 'init';
  overrideMethodEnc = '@@:';

  newMethod1 = 'newMethod1';
  newMethod1Enc = 'v@:';

  newMethod2 = 'newMethod2::';
  newMethod2Enc = 'v@:ii';

  newMethod3 = 'getDouble';
  newMethod3Enc = 'd@:';

  newMethod4 = 'getFloat';
  newMethod4Enc = 'f@:';

  newMethod5 = 'getSmallRecord';
  newMethod5Enc = '{TSmallRecord=ccc}@:';

  varName  = 'myvar';

function imp_init(self: id; _cmd: SEL): id; cdecl;
var
  sp  : objc_super;
begin
  writeln('-init method');
  sp := super(self);
  Result := objc_msgSendSuper(@sp, selector(overrideMethod), []);
end;

procedure imp_newMethod1(self: id; _cmd: SEL); cdecl;
begin
  writeln('called newMethod1');
end;
procedure imp_newMethod2(self: id; _cmd: SEL; a, b: Integer); cdecl;
begin
  writeln('called newMethod2, a = ', a, '; b = ', b);
end;

function imp_newMethod3(self: id; _cmd: SEL): Double; cdecl;
begin
  Result := 1.333;
end;

function imp_newMethod4(self: id; _cmd: SEL): Single; cdecl;
begin
  Result := 3.125;
end;

function imp_getSmallRec(seld: id; _cmd: SEL): TSmallRecord; cdecl;
begin
  Result.a := 121;
  Result.b := 68;
  Result.c := 22;
  Result.d := 5;
end;


procedure RegisterSubclass(NewClassName: PChar);
var
  cl  : _Class;
  b   : Boolean;
begin
  cl := objc_allocateClassPair(objcclass('NSObject'), NewClassName, 0);
  b := class_addMethod(cl, selector(OverrideMethod), @imp_init, overrideMethodEnc) and
       class_addMethod(cl, selector(newMethod1), @imp_newMethod1, newMethod1Enc) and
       class_addMethod(cl, selector(newMethod2), @imp_newMethod2, newMethod2Enc) and
       class_addMethod(cl, selector(newMethod3), @imp_newMethod3, newMethod3Enc) and
       class_addMethod(cl, selector(newMethod4), @imp_newMethod4, newMethod4Enc);
       class_addMethod(cl, selector(newMethod5), @imp_getSmallRec, newMethod5Enc);
  if not b then writeln('failed to add/override some method(s)');

  class_addIvar(cl, varName, sizeof(TObject), 1, _C_PASOBJ);

  objc_registerClassPair(cl);
end;

var
  obj     : id;
  objvar  : Ivar;

  stret   : TSmallRecord;
  varobj  : TObject;
  p     : Pointer;

type
  TgetSmallRecord = function (obj: id; cmd: Sel; arg: array of const): TSmallRecord; cdecl;

begin
  //  if InitializeObjcRtl20(DefaultObjCLibName) then // should be used of OSX 10.5 and iPhoneOS

  if InitializeObjcRtl20(DefaultObjCLibName) then // should be used of OSX 10.4 and lower
    writeln('Objective-C runtime initialized successfuly')
  else begin
    writeln('failed to initialize Objective-C runtime');
    Halt;
  end;

  RegisterSubclass(newClassName);
  writeln('registered');

  obj := AllocAndInit(newClassName);
  {obj := alloc(newClassName);
  objc_msgSend(obj, selector(overrideMethod), []);}

  writeln('sizeof(TSmallRecord) = ', sizeof(TSmallRecord));
  stret := TgetSmallRecord(objc_msgSend_stretreg)(obj, selector(newMethod5), []);
  //writeln('p = ', Integer(p));

  //stret :=
  writeln('stret.a = ', stret.a);
  writeln('stret.b = ', stret.b);
  writeln('stret.c = ', stret.c);
  writeln('stret.d = ', stret.d);

  //PInteger(@stret)^ := Integer(objc_msgSend(obj, selector(newMethod5), []));

  objc_msgSend(obj, selector(newMethod1), []);
  objc_msgSend(obj, selector(newMethod2), [5, 4]);

  writeln('get double = ', objc_msgSend_fpret(obj, selector(newMethod3), []));
  writeln('get float  = ', objc_msgSend_fpret(obj, selector(newMethod4), []));
  release( obj );

  writeln('test successfully complete');
end.


