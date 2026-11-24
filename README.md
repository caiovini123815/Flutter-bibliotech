# BIBLIOTECH – Documentação da Estrutura do Projeto Flutter

## 1. Sobre o projeto

O BIBLIOTECH é um aplicativo desenvolvido utilizando Flutter e Dart, com o objetivo de facilitar o gerenciamento de uma biblioteca.

O aplicativo possui áreas diferentes para administradores e usuários comuns. O administrador pode gerenciar informações relacionadas aos livros, usuários e aluguéis, enquanto o usuário pode acessar sua conta e acompanhar seus próprios aluguéis.

O projeto foi organizado em pastas e arquivos, cada um com uma responsabilidade específica. Essa organização facilita a localização dos códigos, a manutenção do aplicativo e a implementação de novas funcionalidades.

## 2. Estrutura geral do projeto Flutter

Um projeto Flutter possui várias pastas e arquivos na sua estrutura principal. Cada um deles tem uma função diferente para permitir que o aplicativo seja desenvolvido, executado e disponibilizado em diferentes plataformas.

A seguir, estão explicadas as principais partes da estrutura de um projeto Flutter.

### 2.1. Pasta android

A pasta `android` contém os arquivos necessários para executar o aplicativo em dispositivos Android.

Ela reúne as configurações específicas dessa plataforma, como informações do aplicativo, permissões, configurações de compilação e integração com recursos do Android.

De maneira simples, é a parte responsável por permitir que o aplicativo Flutter funcione em celulares e tablets Android.

### 2.2. Pasta ios

A pasta `ios` contém os arquivos necessários para executar o aplicativo em dispositivos Apple, como iPhone e iPad.

Ela possui configurações específicas do sistema iOS, incluindo informações do aplicativo, permissões e configurações utilizadas durante a compilação.

### 2.3. Pasta web

A pasta `web` contém os arquivos necessários para executar o aplicativo por meio de um navegador de internet.

Ela permite que o projeto Flutter também possa ser disponibilizado como uma aplicação web, desde que essa plataforma esteja configurada no projeto.

### 2.4. Pasta windows

A pasta `windows` armazena os arquivos necessários para executar o aplicativo como um programa de computador no sistema operacional Windows.

Ela contém configurações específicas para a compilação e execução nessa plataforma.

### 2.5. Pasta linux

A pasta `linux` contém os arquivos necessários para executar o aplicativo em computadores que utilizam o sistema operacional Linux.

Assim como as pastas de outras plataformas, ela possui configurações próprias para a compilação e execução do aplicativo.

### 2.6. Pasta macos

A pasta `macos` reúne os arquivos necessários para executar o aplicativo em computadores da Apple que utilizam o sistema macOS.

Ela contém configurações específicas dessa plataforma.

### 2.7. Pasta lib

A pasta `lib` é uma das partes mais importantes do projeto, pois armazena o código principal do aplicativo.

É nela que ficam as telas, os serviços, os modelos de dados e as funcionalidades que fazem o BIBLIOTECH funcionar.

Dentro dela, o projeto está organizado em outras pastas.

#### 2.7.1. Pasta core

A pasta `core` armazena recursos gerais que podem ser utilizados em diferentes partes do aplicativo.

Sua finalidade é centralizar funcionalidades compartilhadas, evitando a repetição de código.

##### Pasta services

Armazena os serviços responsáveis por executar tarefas importantes do aplicativo, principalmente a comunicação com o backend.

##### Pasta http

Dentro de `core/services/http`, fica o arquivo `auth_service.dart`.

Esse arquivo é responsável pela autenticação do usuário. Ele realiza o login, recebe e armazena o token de acesso, guarda informações sobre o usuário conectado e permite realizar o logout.

De maneira simples, é a parte que ajuda o aplicativo a reconhecer quem está utilizando o sistema.

#### 2.7.2. Pasta modules

A pasta `modules` organiza as funcionalidades do aplicativo em partes menores.

Cada módulo representa uma área específica do sistema, facilitando a organização e a manutenção do código.

##### Pasta admin

A pasta `admin` armazena as funcionalidades destinadas ao administrador da biblioteca.

É nessa parte que ficam as telas e os serviços utilizados para gerenciar os recursos do sistema.

**Pasta menu**

Armazena a tela principal do administrador, responsável por apresentar as opções de gerenciamento disponíveis no aplicativo.

**Pasta books**

Armazena os arquivos relacionados ao gerenciamento dos livros.

Essa parte permite trabalhar com funcionalidades como cadastrar livros e realizar operações relacionadas ao acervo da biblioteca.

**Pasta services (dentro de books)**

Armazena os serviços responsáveis pela comunicação com o backend para realizar operações relacionadas aos livros.

O arquivo `books_service.dart`, por exemplo, é responsável por enviar solicitações ao servidor.

**Pasta rents**

Armazena as funcionalidades administrativas relacionadas aos aluguéis de livros.

Nessa parte ficam os arquivos responsáveis por consultar, cadastrar e realizar operações relacionadas aos aluguéis.

**Pasta models (dentro de rents)**

Armazena os modelos de dados utilizados para representar as informações dos aluguéis.

Esses modelos ajudam o aplicativo a organizar e interpretar os dados recebidos do backend.

**Pasta services (dentro de rents)**

Armazena os serviços responsáveis por fazer a comunicação com o backend para consultar, cadastrar e devolver aluguéis.

##### Pasta users

A pasta `users` armazena as funcionalidades destinadas aos usuários comuns da biblioteca.

Nela fica a área em que o usuário pode acessar informações relacionadas à sua conta e acompanhar seus próprios aluguéis.

O arquivo `users_dashboard_page.dart` contém a tela principal do usuário.

##### Pasta login

Armazena os arquivos relacionados à tela de login.

É nessa parte que o usuário informa seu e-mail e sua senha para acessar o aplicativo.

Depois da autenticação, o sistema identifica o tipo de conta e direciona o usuário para a área correspondente.

##### Pasta register

Armazena os arquivos relacionados ao cadastro de novos usuários.

Sua função é permitir que novas pessoas preencham seus dados e criem uma conta para utilizar o aplicativo.

##### Pasta forgotpassword

Armazena os arquivos relacionados à recuperação de senha.

Essa funcionalidade permite que o usuário passe pelo processo de recuperação e redefinição de sua senha.

### 2.8. Pasta test

A pasta `test` armazena os arquivos utilizados para realizar testes no aplicativo.

Os testes servem para verificar se determinadas partes do código estão funcionando corretamente.

Por exemplo, é possível criar testes para verificar se uma funcionalidade apresenta o resultado esperado.

Essa pasta ajuda a encontrar problemas antes que eles afetem os usuários.

### 2.9. Pasta assets (quando utilizada)

A pasta `assets` é utilizada para armazenar arquivos que o aplicativo precisa carregar, mas que não são códigos Dart.

Ela pode conter imagens, ícones, fontes, arquivos de áudio e outros recursos visuais.

Por exemplo, caso o BIBLIOTECH utilize uma imagem de logotipo, ela pode ficar armazenada nessa pasta.

Para que esses arquivos sejam reconhecidos pelo Flutter, eles precisam ser declarados no arquivo `pubspec.yaml`.

### 2.10. Pasta build

A pasta `build` armazena os arquivos gerados automaticamente durante o processo de compilação do aplicativo.

Esses arquivos são utilizados pelo Flutter para preparar o aplicativo para execução ou distribuição.

Normalmente, não é necessário editar manualmente os arquivos dessa pasta.

### 2.11. Pasta .dart_tool

A pasta `.dart_tool` armazena arquivos internos utilizados pelas ferramentas do Dart e do Flutter.

Ela contém informações que ajudam o ambiente de desenvolvimento a organizar dependências e executar tarefas do projeto.

É uma pasta gerada automaticamente e não costuma precisar de alterações manuais.

### 2.12. Pasta .idea (quando utilizada)

A pasta `.idea` armazena configurações relacionadas ao ambiente de desenvolvimento Android Studio ou IntelliJ.

Ela pode guardar preferências e configurações utilizadas para abrir e trabalhar com o projeto nesses programas.

## 3. Principais arquivos da raiz do projeto

Além das pastas, o Flutter possui arquivos importantes na parte principal do projeto.

### 3.1. Arquivo main.dart

O arquivo `main.dart` fica dentro da pasta `lib` e é o ponto de entrada do aplicativo.

É nele que o Flutter começa a executar o sistema.

Esse arquivo configura o aplicativo, define sua inicialização e organiza as rotas de navegação.

As rotas são os caminhos utilizados para levar o usuário de uma tela para outra.

No BIBLIOTECH, por exemplo, depois de realizar o login, o aplicativo verifica se a conta pertence a um administrador ou a um usuário comum e direciona cada um para sua respectiva área.

### 3.2. Arquivo pubspec.yaml

O arquivo `pubspec.yaml` é responsável por armazenar as configurações principais do projeto Flutter.

Nele ficam informações como o nome do projeto, a versão, as dependências utilizadas e os arquivos adicionais que precisam ser carregados pelo aplicativo.

As dependências são bibliotecas prontas que adicionam funcionalidades ao projeto.

Por exemplo, o BIBLIOTECH utiliza bibliotecas para realizar requisições HTTP e armazenar informações de forma segura.

### 3.3. Arquivo pubspec.lock

O arquivo `pubspec.lock` registra as versões exatas das dependências instaladas no projeto.

Sua função é ajudar a manter as mesmas versões das bibliotecas quando o projeto é executado em diferentes computadores.

Ele é atualizado automaticamente pelo gerenciador de dependências.

### 3.4. Arquivo analysis_options.yaml

Esse arquivo armazena configurações utilizadas para analisar o código Dart.

Ele ajuda a identificar possíveis erros, avisos e problemas de organização no código durante o desenvolvimento.

### 3.5. Arquivo .gitignore

O arquivo `.gitignore` informa quais arquivos e pastas não devem ser enviados para o controle de versão Git.

Isso evita que arquivos temporários, configurações locais e outros conteúdos desnecessários sejam incluídos no repositório do projeto.

### 3.6. Arquivo README.md

O arquivo `README.md` contém a documentação do projeto.

Ele apresenta informações sobre o aplicativo, sua finalidade, sua organização e orientações importantes para quem deseja conhecer ou executar o sistema.

### 3.7. Arquivo .metadata

O arquivo `.metadata` armazena informações utilizadas pelo Flutter para acompanhar características e configurações relacionadas ao projeto.

Ele é gerenciado automaticamente pelas ferramentas do Flutter.

## 4. Como as partes do aplicativo trabalham juntas

O BIBLIOTECH funciona por meio da comunicação entre suas telas, serviços e backend.

As telas são responsáveis por apresentar as informações e receber os dados digitados pelo usuário.

Os serviços são responsáveis por enviar e receber informações do backend.

O backend processa as solicitações, aplica as regras do sistema e realiza as operações necessárias no banco de dados.

Por exemplo, quando um administrador cadastra um livro, ele preenche as informações na tela de cadastro. Em seguida, o serviço responsável envia esses dados ao backend, que processa o cadastro e armazena as informações.

Da mesma forma, quando um usuário realiza o login, o aplicativo envia o e-mail e a senha para o backend. Após a autenticação, recebe as informações necessárias para permitir o acesso à área correspondente.

## 5. Organização geral do projeto

A estrutura do BIBLIOTECH separa as responsabilidades para facilitar o desenvolvimento:

- `android`: arquivos para executar o aplicativo em dispositivos Android.
- `ios`: arquivos para executar o aplicativo em dispositivos Apple.
- `web`: arquivos para executar o aplicativo em navegadores.
- `windows`: arquivos para executar o aplicativo no Windows.
- `linux`: arquivos para executar o aplicativo no Linux.
- `macos`: arquivos para executar o aplicativo no macOS.
- `lib`: armazena o código principal do aplicativo.
- `lib/core`: reúne recursos compartilhados.
- `lib/modules`: reúne as funcionalidades separadas por áreas.
- `test`: armazena os testes do aplicativo.
- `assets`: pode armazenar imagens, ícones e outros recursos.
- `build`: armazena arquivos gerados durante a compilação.
- `.dart_tool`: guarda arquivos internos das ferramentas Dart e Flutter.
- `.idea`: pode armazenar configurações do Android Studio.
- `pubspec.yaml`: define as configurações e dependências do projeto.
- `pubspec.lock`: registra as versões das dependências.
- `analysis_options.yaml`: configura a análise do código.
- `.gitignore`: define o que não deve ser enviado ao Git.
- `README.md`: apresenta a documentação do projeto.

**Observação:** algumas dessas pastas, como `web`, `windows`, `linux`, `macos`, `assets` e `.idea`, podem não existir em todos os projetos. Elas dependem das plataformas habilitadas e das configurações utilizadas no desenvolvimento.

## 6. Conclusão

A estrutura do BIBLIOTECH foi desenvolvida para manter o código organizado e facilitar o entendimento de cada funcionalidade.

Cada pasta e arquivo possui uma responsabilidade específica, permitindo que as alterações sejam realizadas de maneira mais organizada.

A separação entre telas, serviços, modelos e configurações também facilita a identificação de possíveis erros, a manutenção do aplicativo e a inclusão de novas funcionalidades no futuro.

Dessa forma, o projeto fica mais fácil de compreender, desenvolver e expandir.
