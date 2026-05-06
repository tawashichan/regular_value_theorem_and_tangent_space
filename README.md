# regular_value_theorem_and_tangent_space

## PDF の生成

Docker が起動している状態で次を実行します。

```sh
./build_pdf_in_container.sh
```

デフォルトでは `main.tex` から `main.pdf` を生成します。別の TeX ファイルを指定する場合は、引数に渡します。

```sh
./build_pdf_in_container.sh path/to/file.tex
```

Docker イメージを作り直したい場合は次のようにします。

```sh
REBUILD_IMAGE=1 ./build_pdf_in_container.sh
```
