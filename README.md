# 🛠️ C++ Utils Script

Um script em Bash para automatizar o processo de build, execução e debug de projetos em C++.
Ele suporta tanto projetos simples com `g++` quanto projetos com `CMake`, além de integrar ferramentas como `gdb` e `valgrind`.

---

## 📦 Funcionalidades

* 🔨 Build automático com `g++` ou `cmake`
* 🚀 Execução após build
* 🧹 Limpeza de diretórios de build
* 🐞 Debug com `gdb`
* 🧠 Análise de memória com `valgrind`
* ⚙️ Inicialização de projetos C++ com template
* 📜 Download automático da licença GPLv2
* 🎨 Output colorido e organizado

---

## 📁 Estrutura gerada

Ao usar `--init`, o script cria:

```
.
├── CMakeLists.txt
├── include/
└── src/
    └── main.cpp
```

---

## ⚙️ Dependências

### Para projetos com g++

* g++

### Para projetos com CMake

* cmake
* make
* curl

### Opcionais

* gdb
* valgrind

---

## 🚀 Uso

Você pode usar o script assim:

```
./cpp_utils [opções]
```

ou, se configurado no PATH:

```
cpp [opções]
```

---

## 🧾 Opções disponíveis

| Opção               | Descrição                 |
| ------------------- | ------------------------- |
| `-r`, `--run`       | Executa após o build      |
| `-f`, `--full`      | Limpa e recompila         |
| `-v`, `--version`   | Define versão do C++      |
| `-c`, `--clean`     | Remove build              |
| `-d`, `--debug`     | Build em modo debug       |
| `-R`, `--release`   | Build em modo release     |
| `-b`, `--build-dir` | Define diretório de build |
| `-n`, `--name`      | Nome do binário           |
| `-i`, `--init`      | Inicializa projeto        |
| `-l`, `--license`   | Mostra licença GPLv2      |
| `--gdb`             | Executa com GDB           |
| `--valgrind`        | Executa com Valgrind      |
| `-h`, `--help`      | Mostra ajuda              |

---

## 🧪 Exemplos

### Build simples

```
./cpp_utils
```

### Build e executar

```
./cpp_utils --run
```

### Build debug com GDB

```
./cpp_utils --gdb
```

### Análise de memória

```
./cpp_utils --valgrind
```

### Limpar build

```
./cpp_utils --clean
```

### Inicializar projeto

```
./cpp_utils --init
```

---

## ⚙️ Configuração de Templates

O script usa templates localizados junto ao script:

Arquivos esperados:

* `CMakeLists.txt`
* `main.cpp`

Você pode modificar esses templates para criar sua própria base de projeto.

---

## 🧠 Como funciona

1. Detecta automaticamente o tipo de projeto:

   * `CMakeLists.txt` → usa CMake
   * arquivos `.cpp` → usa g++

2. Verifica dependências

3. Executa:

   * build
   * run/debug (opcional)

---

## 📜 Licença

Este projeto utiliza a licença **GPLv2**.
Você pode visualizar com:

```
./cpp_utils --license
```

---

## 🐱 Autor

Script criado para facilitar o desenvolvimento em C++ com foco em produtividade e automação.

---

## ⭐ Dica

Adicione ao seu PATH para usar como comando global:

```
mv cpp_utils /usr/local/bin/cpp
chmod +x /usr/local/bin/cpp
```

---

## 👋 Final

Um utilitário simples, rápido e poderoso para projetos em C++ no terminal.

---
