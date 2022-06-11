# Build & Install
```bash
./configure
make
make install
```

To list options, use `./confiture --help`.

FFTW 3 defaults to double precision. Use `--enable-float` or `--enable-single` to enable single precision.

Enable x86 and x64 SIMD.

```bash
--enable-sse --enable-sse2 --enable-avx --enable-avx2 --enable-avx512 --enable-avx-128-fma
```

More SIMD and fma instruction. `--enable-generic-simd*` options compiles to different code path.

```bash
--enable-generic-simd128 --enable-generic-simd256 --enable-fma
```

Disable fortran.

```bash
--disable-fortran
```

Set install location.

```bash
--prefix=/home/cu/code/cpp/fftCompare/install
```

## `./configure` 
Linux.

```
./configure --with-pic=yes --enable-single --enable-sse2 --enable-avx --enable-avx2 --enable-avx512 --enable-avx-128-fma --enable-fma --disable-fortran --prefix=/home/cu/code/cpp/fftCompare/install
```

# Windows build
## MSVC
CMake can be used.

```powershell
cd fftw-<version>

mkdir build
cd build

cmake ..
cmake-gui.exe .
cmake --build . --config release
```

To build static library, turn off `BUILD_SHARED_LIBS`.

Library is built in `build/Release` directory. Header is at `api/fftw3.h`.

- [mingw - Build FFTW lib with Visual Studio 2015 [added: steps for VS 2019] - Stack Overflow](https://stackoverflow.com/questions/35517892/build-fftw-lib-with-visual-studio-2015-added-steps-for-vs-2019)

## MSYS2
I wasn't able to use MSYS2 static build (libfftw3.a etc.) with MSVC.

There's also a package available on MSYS2.

- [Package: mingw-w64-x86_64-fftw - MSYS2 Packages](https://packages.msys2.org/package/mingw-w64-x86_64-fftw)

`./configure` options.

```bash
mkdir build
cd build

# Single thread.
../configure --host=x86_64-w64-mingw32 --disable-alloca --with-our-malloc --enable-single --enable-sse2 --enable-avx --enable-avx2 --enable-fma --enable-avx-128-fma --disable-fortran --prefix="$HOME/code/fft/install" && make -j && make install

# With multi-threading.
../configure --host=x86_64-w64-mingw32 --disable-alloca --with-our-malloc --enable-single --enable-sse2 --enable-avx --enable-avx2 --enable-fma --enable-avx-128-fma --disable-fortran --enable-threads --prefix="$HOME/code/fft/install" && make -j
```

```bash
for lib in *.a; do echo $lib; ar -t $lib | grep gettime; done > result
```

- `libgcc.a`
- `libmingw32.a`
- `libmingwex.a`
- And more.

Still missing library for `fprintf` and `__getreent`. Also `libmingw32.a` contains a symbol that conflicts with `MSVCRT.lib`.

```
libmingw32.a(lib64_libmingw32_a-tlssup.o) : warning LNK4078: multiple '.CRT' sections found with different attributes (
C0400040) [C:\Users\Golwond\code\vst\Plugins\build\CubicPadSynth\CubicPadSynth.vcxproj]
MSVCRT.lib(gs_report.obj) : error LNK2005: __report_gsfailure already defined in libmingw32.a(lib64_libmingw32_a-gs_sup
port.o) [C:\Users\Golwond\code\vst\Plugins\build\CubicPadSynth\CubicPadSynth.vcxproj]
```

```
libfftw3f.a(assert.o) : error LNK2019: unresolved external symbol __getreent referenced in function fftwf_assertion_fai
led [C:\Users\Golwond\code\vst\Plugins\build\CubicPadSynth\CubicPadSynth.vcxproj]
libfftw3f.a(assert.o) : error LNK2019: unresolved external symbol fprintf referenced in function fftwf_assertion_failed
 [C:\Users\Golwond\code\vst\Plugins\build\CubicPadSynth\CubicPadSynth.vcxproj]
C:\Users\Golwond\code\vst\vst3sdk\build\VST3\Release\CubicPadSynth.vst3\Contents\x86_64-win\CubicPadSynth.vst3 : fatal
error LNK1120: 2 unresolved externals [C:\Users\Golwond\code\vst\Plugins\build\CubicPadSynth\CubicPadSynth.vcxproj]
```

- [From MinGW static library (.a) to Visual Studio static library (.lib) - Stack Overflow](https://stackoverflow.com/questions/2096519/from-mingw-static-library-a-to-visual-studio-static-library-lib)
- [c++ - Contents of a static library - Stack Overflow](https://stackoverflow.com/questions/3757108/contents-of-a-static-library/21320738)

# File location
Following 2 files are necessary.

- `.libs/libfftw3.a`
- `api/fftw3.h`

# Benchmark

# Linking
When linking with g++ (or clang++), order of options is important.

```bash
g++ -O3 main.cpp -lm libfftw3f.a   # Correct.
# g++ -O3 -lm libfftw3f.a main.cpp # Incorrect. Link fails.
```

- [How to Link Static Library in C/C++ using GCC compiler? | Technology of Computing](https://helloacm.com/how-to-link-static-library-in-cc-using-gcc-compiler/)
- [c++ - .o files vs .a files - Stack Overflow](https://stackoverflow.com/questions/654713/o-files-vs-a-files)
- [c - unable to link to fftw3 library - Stack Overflow](https://stackoverflow.com/questions/25568027/unable-to-link-to-fftw3-library)
- [g++ linking order dependency when linking c code to c++ code - Stack Overflow](https://stackoverflow.com/questions/3363398/g-linking-order-dependency-when-linking-c-code-to-c-code)

# Reference
`./configure` recipe.

- [homebrew-core/fftw.rb at master · Homebrew/homebrew-core · GitHub](https://github.com/Homebrew/homebrew-core/blob/master/Formula/fftw.rb)

Runtime SIMD detection.

- [Re: [easybuild] FFTW modules: avx2 vs sse2](https://www.mail-archive.com/easybuild@lists.ugent.be/msg02656.html)
- [Re: fftw: Usage of SSE in 64bit?](https://lists.debian.org/debian-science/2011/06/msg00080.html)
- [fftw runtime cpu detection](https://lists.gnu.org/archive/html/guix-devel/2018-04/msg00091.html)

## FFTW documentation
- [FFTW 3.3.8: Installation on Unix](http://fftw.org/fftw3_doc/Installation-on-Unix.html#Installation-on-Unix)
- [FFTW Installation on the MacOS](http://www.fftw.org/install/mac.html)
- [FFTW Installation on Windows](http://fftw.org/install/windows.html)
