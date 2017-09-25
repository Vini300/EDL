# Trabalho de Estrutura de Linguagens

Alunos: Vinícius Soares, Daniel José, Bernardo Duarte

# Haskell:

## História:

Haskell tem suas principais inspirações centradas em 2 ideias: Programação Funcional e Avaliação Preguiçosa.

A Programação Funcional, implementada primeiramente na linguagem Lisp, tem sua origem na Programação Declarativa, que é um paradigma de programação focado em descrever logicamente o que deve ser feito por um programa sem descrever um fluxo de controle. A programação funcional evoluiu com a adição de Funções Lambda, e definições de função por meio de padrões. As linguagens das quais Haskell baseou suas idéias de programação funcional foram Scheme e ML.

No lado da Avaliação Preguiçosa, a ideia de funções que não avaliam seus parâmetros imediatamente começou por volta dos anos 70 e, com isso, houve uma enorme quantidade de linguagens de programação funcionais criadas com o conceito de avaliação preguiçosa.
Em 1987, então, em uma conferência sobre Programação Funcional, os presentes decidiram criar uma linguagem funcional unificada, pois a grande quantidade de linguagens deste estilo tornava difícil o compartilhamento de código entre programadores, já que não havia unificação nas linguagens e compiladores utilizados.

Com isso, eles decidiram utilizar uma linguagem existente e aprimorá-la para servir o propósito. A linguagem escolhida foi Miranda, porém o criador desta linguagem não aceitou o pedido. Assim, foi criado um comitê daqueles que iriam desenvolver esta “linguagem unificada”, que foi nomeado “Haskell Committee”. Então, o documento que determinou a criação da linguagem Haskell foi publicado em 1º de Abril de 1990.

## Classificação:

Haskell é uma linguagem funcional pura, utilizando conceitos de programação declarativa e de avaliação preguiçosa como bases da linguagem. Na questão de estaticidade e dinamicidade, a linguagem Haskell é uma linguagem estritamente estática, por ter uma tipagem forte, e ser uma linguagem compilada, sem poder ser feita uma avaliação e compilação de código durante o runtime.

A linguagem Haskell é utilizada, em geral, para tarefas com grande carga de trabalho, com uso de programação paralela. Também é bastante utilizada para o desenvolvimento de ferramentas. Alguns exemplos são o sistema de filtragem de spam do Facebook, o sistema de suporte de infraestrutura de TI da Google, e o sistema de serialização de dados da Microsoft, chamado Bond.

## Funções de Alta Expressividade:

### Tipos Algébricos de Dados:

Tipos Algébricos de Dados são tipos de dados que podem assumir diferentes formas dependendo do modo como eles são construídos. Eles são úteis para a construção de tipos de dados que possuem comportamento tanto complexo quanto simples, podendo haver um, nenhum ou múltiplos campos. Eles são criados pela palavra chave **data** que determina o nome do tipo, este tendo que começar com letra maiúscula. O comportamento desses tipos algébricos é definido pelos seus construtores que são expressões que definem os tipos que serão utilizados pelos seus campos. Cada construtor define um conjunto específico de campos, podendo diferenciar entre construtores de um mesmo tipo algébrico.
  
A escrita de um tipo de dado algébrico com somente um construtor que possui um ou mais campos tem o mesmo propósito de uma **struct** em C, o tipo algébrico será um tipo que armazena um conjunto de tipos de uma forma única.

```C
//Struct em C
struct Livro {
    int isbn;
    char* title;
    char** authors;
};
```

```Haskell
--Struct usando data em Haskell
data Livro = Livro Int String [String]
            deriving (Show)
```

Um tipo de dado algébrico que possui vários construtores, porém nenhum deles possui campo tem o mesmo propósito de uma enumeração em C, visto que qualquer construção será do mesmo tipo algébrico porém cada uma possuirá seu próprio significado.
Caso implementado derivando a class **Eq** será de fato igual a uma enumeração.

```C
//Enum em C
enum Dia {
    Domingo,
    Segunda,
    Terca,
    Quarta,
    Quinta,
    Sexta,
    Sabado
};
```

```Haskell
--Enum usando data em Haskell
data Dia
    = Domingo
    | Segunda
    | Terca
    | Quarta
    | Quinta
    | Sexta
    | Sabado
    deriving (Eq, Show)
```

O tipo de dado algébrico permite também seu uso sem a declaração específica de tipos podendo ser declarada de forma a referenciar os tipos a partir daqueles que serão passados como parâmetros aos construtores, essa é a forma paramétrica. A equivalência dessa forma com C seriam os ponteiros genéricos e com os Templates em C++.

```C
//Void em C
struct node {
    void* data;
    struct node* next;
};
```

```Haskell
--Void em Haskell
data Lista = Vazia | Cons a (Lista a)
    deriving (Show)
```

Por fim existem os tipos recursivos. Estes, por sua vez, são implementados de forma a se auto referenciar dentro de um dos campos de seus construtores, surgindo então uma recursão. Normalmente esse tipos algébricos recursivos são acompanhados de construtores Nulos, onde se é definido um construtor sem campos que serve de indicador de dado vazio. Exemplos de utilização são listas e árvores, estruturas de dados que inclusive possuem estruturas similares nas outras linguagens, como em C e C++ com o uso de ponteiros.

```C
//Altura de arvore em C
struct node {
    void* value;
    struct node* left, right;
};
int height(struct node* tree)
{ 
    if (tree == NULL) return 0;
    return 1 + max(height (tree->left), height (tree->right)); 
}
```

```Haskell
--Altura da arvore em Haskell
data Tree a = EmptyNode
        | Node a (Tree a) (Tree a)
        deriving (Show)
depth :: (Tree a) -> Int
depth EmptyNode = 0
depth (Node _ l r) = 1 + max (depth l) (depth r)
```

A vantagem do uso de tipos algébricos surge pela sua capacidade de adicionar expressividade ao código, pois ao criarmos nossos tipos iremos criar uma linguagem nossa de forma a nos comunicar através da mesma dentro do próprio código, o que gera uma **Linguagem Específica do Domínio**.

Outra grande utilidade vem por garantir operações com segurança de tipagem, onde em tempo de compilação o compilador será capaz de determinar se existem erros dentro do seu código. Então, mesmo que sejam utilizadas abstrações de tipos como Num, se for feita uma implementação utilizando Int, junto com Float, o compilador conseguirá descobrir e alertará ao programador sobre o erro. Isso se dá por causa da sua capacidade de implementar tipos **genéricos**.

### Genéricos

A definição de variável genérica é uma variável que aceita valores de quaisquer tipos, sem restringir a uma definição de tipo específica. No caso de Haskell, tipos de dado genéricos são determinados pelo tipo **data**. A ideia de genéricos em Haskell também é diferente a de outras linguagens de programação pois, em Haskell, tipos genéricos são feitos por meio de polimorfismo. O tipo **data** determina um tipo que aceita qualquer valor. Por exemplo, uma lista de **data** pode aceitar qualquer valor, de inteiros a funções, e até outras listas. Há também a possibilidade de limitar os dados que podem ser atribuídos a uma declaração de tipo genérica, utilizando a ideia de tipos algébricos de dados.

As funções são naturalmente genéricas, já que o compilador assume que, caso não haja uma declaração direta de tipo, os atributos são do tipo mais genérico possível. Portanto, se uma função é declarada usando apenas pattern matching como checagem de atributo, a função executaria corretamente com qualquer tipo que fosse passado.

#### Exemplos:

O seguinte trecho de código, em Haskell, define um tipo lista genérica, cria duas listas, uma contendo 1,2,3 e outra contendo 4,5,6, define uma função **unir** que faz a união das duas listas e retorna uma lista unida, e depois imprime na tela a lista unida.

```Haskell
--Uniao de listas em Haskell
infixr 5 :-:
data Lista a = Vazio | a :-: (Lista a) deriving (Show)
unir :: Lista a -> Lista a -> Lista a
unir Vazio ys = ys
unir (x :-: xs) ys = x :-: (unir xs ys)
l1 = 1:-:2:-:3:-:Vazio
l2 = 4:-:5:-:6:-:Vazio
main :: IO ()
main = do let result = (unir l1 l2)
          putStrLn(show result)
```

O seguinte trecho de código, em C++, é similar ao de Haskell, definindo uma classe de lista genérica, com a função **join** que faz a união de duas listas, adicionando a segunda lista ao fim da primeira, e depois imprime na tela a lista unida.

```C++
//Uniao de listas em C++
#include <iostream>

template <typename T>
class Lista {
public:
    struct No {
    public:
        T dado;
        No* prox;
    };
    No* inicio;
    int tamanho;

    Lista() {
        inicio = nullptr;
        tamanho = 0;
    }

    Lista(int vet[], int tam) {
        for (int i = 0; i < tam; i++) {
            append(vet[i]);
        }
        tamanho = tam;
    }

    void append(T elem) {
        No* atual = inicio;
        for (int i = 1; i < tamanho; i++) {
            atual = atual->prox;
        }
        No* no = new No();
        no->dado = elem;
        no->prox = nullptr;
        if (tamanho == 0) {
            inicio = no;
        }
        else {
            atual->prox = no;
        }
        tamanho++;
    }

    void join(Lista l) {
        if (l.tamanho == 0) {
            return;
        }
        No* atual = inicio;
        for (int i = 1; i < tamanho; i++) {
            atual = atual->prox;
        }
        atual->prox = l.inicio;
        tamanho = tamanho + l.tamanho;
    }

    friend std::ostream& operator<<(std::ostream& os, const Lista<T>& lista) {
        No* atual = lista.inicio;
        os << atual->dado;
        for (int i = 1; i < lista.tamanho; i++) {
            os << ",";
            atual = atual->prox;
            os << atual->dado;
        }
        return os;
    }
};

int main(void) {
    int vet1[] = { 1,2,3 };
    int vet2[] = { 4,5,6 };
    Lista<int> l1(vet1, 3);
    Lista<int> l2(vet2, 3);
    l1.join(l2);
    std::cout << l1 << std::endl;
}
```
Comparando estes 2 trechos, é visível que, no exemplo de Haskell, o código é bem mais conciso, e requer bem menos definições, pelo fato da lista ser composta por meio de pattern matching, e a definição da lista é bem mais simples, pelo uso de tipos algébricos e do tipo **data**. Em C++, é necessário o uso de Templates para que seja feito a mesma definição de lista e, mesmo se removendo toda a parte definição em si da lista, ainda seriam mais complexos tanto a definição da lista quanto a instanciação da mesma. Portanto, mesmo o código em C++ sendo mais facilmente entendível por meio da leitura, é mais complexo em sua escrita, por necessitar de constantes declarações de Templates.

Sobre funções genéricas, o seguinte trecho de código, em Haskell, define a função **troca** como uma função que pega uma tupla e cria uma nova tupla com a ordem dos valores trocada.

```Haskell
--Troca em Haskell
troca (x,y) = (y,x)
val1 = 1
val2 = 2
val3 = 'a'
val4 = [1,2,3]
main :: IO()
main = do let result = (troca(val1,val2))
          putStrLn(show result)
          let result = (troca(val2,val3))
          putStrLn(show result)
          let result = (troca(val3,val4))
          putStrLn(show result)
          
```

O seguinte trecho de código, em C++, faz algo similar ao de Haskell, recebendo um par definido por um **struct** e usando templates para fazer a função ser genérica.

```Cpp
//Troca em C++
#include <iostream>

template <typename T, typename G>
struct par {
    T um;
    G dois;
};

template <typename T, typename G>
par<G,T> troca (par<T,G> p) {
    par<G,T> pInv;
    pInv.um = p.dois;
    pInv.dois = p.um;
    return pInv;
}

int main(void) {
    par<int,int> par1;
    par1.um = 1; par1.dois = 2;
    par1 = troca(par1);
    std::cout << "(" << par1.um << ", " << par1.dois << ")";
    par<int,char>par2;
    par2.um = 1; par2.dois = 'a';
    par<char,int>par3;
    par3 = troca(par2);
    std::cout << "(" << par3.um << ", " << par3.dois << ")";
    par<char,int*>par4;
    int vet[] = {1,2,3};
    par4.um = 'a'; par4.dois = vet;
    par<int*,char>par5;
    par5 = troca(par4);
    std::cout << "(" << par5.um << ", " << par5.dois << ")";
}
```

Portanto, há uma grande diferença, pois em C++ são necessárias várias definições de templates diferentes, e vários usos de templates, para fazer as mesmas operações que, em Haskell, são apenas definidas por meio de uma definição de lógica. Por isso, Haskell possui muito mais redigibilidade neste ponto, por ter códigos muito mais concisos, mas há alguma perda de legibilidade. Porém, a lógica de entendimento das funções genéricas em Haskell é bem mais direta do que em C++, aumentando assim a expressividade da linguagem neste ponto. 

### Tipos e Funções Polimórficas:

Polimorfismo é a ideia de criar um tipo “mais genérico” que engloba um ou mais tipos “mais especializados”, para que seja feito o armazenamento e a passagem de argumentos com o tipo “mais genérico”, e que operações sejam feitas sobre os tipos “mais especializados”, simplificando assim o código escrito por fora das funções.

Em Haskell, é possível fazer tipos polimórficos, por meio do uso do conceito de Genéricos e de Tipos Algébricos de Dados. Com a utilização de um tipo **data** limitado por definições algébricas, podem ser feitas funções ou estruturas de dados que recebem um tipo “mais genérico” que posteriormente pode ser reconhecido como um tipo “mais especializado” e ter operações feitas sobre ele. Polimorfismo é uma parte intrínseca da definição da linguagem Haskell, e portanto é simples e intuitivo de ser utilizado, apenas necessitando de checagens algébricas em todos os pontos em que polimorfismo seria utilizado.

#### Exemplos:

No seguinte trecho de código em Haskell, é definido o tipo Forma, que pode ser tanto um Triângulo, quanto um Retângulo, quanto um Quadrado, cada um com seu próprio construtor, definido pelos tipos algébricos. Então, o programa gera um Triângulo, um Quadrado e um Retângulo, e usa a definição da função polimórfica area para calcular a área de cada uma das formas, utilizando a mesma chamada de função para cada uma.

```Haskell
--Polimorfismo de Forma em Haskell
data Forma = Triangulo Float Float | Retangulo Float Float | Quadrado Float
area :: Forma -> Float
area (Triangulo x y) = (x*y)/2
area (Quadrado x) = x*x
area (Retangulo x y) = x*y
t = Triangulo 3 5
r = Retangulo 5 10
q = Quadrado 3
main = do let result = (area(t))
          putStrLn(show result)
          let result = (area(r))
          putStrLn(show result)
          let result = (area(q))
          putStrLn(show result)
```

Por outro lado, o mesmo código em C++ necessita da definição de classes, e não é possível realmente fazer uma função genérica capaz de descobrir se a forma passada é um retângulo, quadrado ou triângulo e calcular a área deste, mas é possível fazer uma classe “pai” que contém o método abstrato area(), e depois implementar um area() para cada uma das diferentes formas, para por fim poder executar o comando area() de um ponteiro para Forma, fazendo o método calcular corretamente a área da forma.

```Cpp
//Polimorfismo de Forma em C++
#include <iostream>

class Forma {
    public:
         virtual float area() = 0;
};
class Triangulo : public Forma {
    public:
        float base;
        float altura;
        Triangulo(float b, float a) {
            base = b;
            altura = a;
        }
        float area() {
            return (base*altura)/2;
        }

};
class Retangulo : public Forma {
    public:
        float compr;
        float altura;
        Retangulo(float c, float a) {
            compr = c;
            altura = a;
        }
        float area() {
            return compr * altura;
        }
};
class Quadrado : public Forma {
    public:
        float lado;
        Quadrado(float l) {
            lado = l;
        }
        float area() {
            return lado * lado;
        }
};
int main(void) {
    Triangulo t(3, 5);
    Retangulo r(5, 10);
    Quadrado q(3);
    Forma* f[3];
    f[0] = &t;
    f[1] = &r;
    f[2] = &q;
    for (int i = 0; i < 3; i++) {
        std::cout << f[i]->area() << std::endl;
    }
}
```

Portanto, em C++, além do código ser mais longo, é mais complexo de ser lido, e a lógica por trás é bem mais complexa, por necessitar de conceitos como herança de classes e funções/classes virtuais.

### Avaliação Preguiçosa:

Haskell é uma linguagem que usa a estratégia de lazy evaluation ao avaliar expressões. Essa estratégia, conhecida também como call-by-need, consiste em apenas calcular o valor de uma expressão quando seu valor realmente é necessário. Isso evita que sejam realizados cálculos desnecessários, pois mesmo um valor passado a uma função, quando não utilizado, não é calculado.

Por exemplo, se um código semelhante ao trecho de código abaixo fosse rodado em uma linguagem que não usa a avaliação preguiçosa, o programa nunca pararia, mas como o argumento problemático nunca é utilizado o programa roda sem problemas.

```Haskell
--Funcao "infinita" em Haskell
funcao x y = x
a = funcao 10 [1,2,..]
```

Torna-se possível, portanto:
* Definir estruturas infinitas.
* Definir suas próprias expressões de fluxo de controle.

Em contrapartida, a legibilidade do código é prejudicada ao realizar esse tipo de avaliação pois, ao se ler o código, não se consegue determinar com facilidade em que parte do código uma expressão está realmente sendo calculada. Além disso, podem acontecer casos onde o custo para se armazenar uma expressão pode superar de maneira considerável o custo para se armazenar o resultado dela, o que pode causar problemas de armazenamento de memória que não são facilmente detectáveis.

#### Fluxo de Controle:

Na linguagem C não podemos redefinir expressões de fluxo de controle como, por exemplo, o if, sem utilizar o if.

Em Haskell, diferentemente de C, podemos definir utilizando pattern matching uma estrutura que age de maneira semelhante:

```Haskell
--Redefinicao do if em Haskell
if' True x _ = x
if' False _ y = y 
```

#### Listas Infinitas:

Graças a essa estratégia podemos, portanto, definir uma lista de tamanho infinito. Com essa facilidade, podemos simplesmente definir as regras para a geração de uma sequência em vez de precisarmos gerar os valores que usaremos individualmente antes mesmo de utilizá-los.

Podemos, por exemplo, expressar a sequência de fibonacci como uma sequência recursiva infinita.

```Haskell
--Fibonacci em Haskell
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
```

Por causa da maneira que o Haskell guarda as expressões na memória, esse fibonacci também possui memorização.

Ao utilizarmos essa sequência como argumento de alguma outra função, (contanto que essa operação seja finita, já que funções que dependem apenas da lista infinita como a função length não podem ser utilizadas nesse tipo de lista) a operação só calculará os valores da sequência que forem necessários.

```Haskell
--Fibonacci completo em Haskell
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
lista = [1,2,3,4,5]
resultado = zipWith (*) lista fibs
```

Para fazer uma função semelhante em C, é necessário calcular primeiro um vetor com os valores da sequência necessários ou então utilizar parte de um vetor de memorização já preenchido, tornando o código bem mais extenso e até mesmo mais difícil de entender.

```C
//Fibonacci em C
void fib(int* table,int n) 
{
    table[0] = table[1] = 1;
    for (int i = 2; i <= n; ++i) {
        table[i] = table[i-1] + table[i-2];
    }
}

int main(void){
    int n = 20;
    int table[n+1];
    fib(&table,n);
    int vetor[] = {1,2,3,4,5};
    int tamvetor = 5;
    int resultado[tamvetor];
    for (int i = 0;i < tamvetor;i++){
        resultado[i] = vetor[i] * table[i];
    }
}
```

### Compreensão de Listas:

Compreensão de lista é um tipo de sintaxe presente em Haskell que permite criar listas utilizando outras listas já existentes. Ela se inspira na notação matemática de conjuntos.

Se quiséssemos uma lista das potências de dois por exemplo. Em C, utilizamos um loop para criar um vetor com um número finito de potências, 

```C
//Potencias de vetor em C
void potencias(double vet[],int tamanho){
    for(unsigned int i = 0;i < tamanho; i++){
        vet[i] = pow(2.0,i);
    }
}

int main(void){
    double vet[20];
    potencias(vet,20);
    printf("%f",vet[10]);
}
```

mas utilizando compreensão de listas e listas infinitas podemos simplesmente definir a seguinte lista:

```Haskell
--Potencias de Lista Infinita em Haskell
potencias = [2**x | x <- [0..]]
```

Para retirar as mesmas 20 potências do exemplo em C podemos simplesmente utilizar a função take:

```Haskell
--Potencias de Lista Infinita em Haskell
conjunto = [2**x | x <- [0..]]
potencias = take 20 conjunto
```

Podemos também aninhar quantas condições quisermos na geração de uma lista, utilizar mais de uma lista já existente para gerar nossa lista e ainda declarar variáveis que utilizaremos utilizando a palavra reservada let.

```Haskell
--Uso de let para conjunto em Haskell
conjunto = [z | x <- [1..20], y <- [1..20] , let z = x*y, z /= 13, z /= 17, z /= 19, z `mod` 3 /= 0, z `mod` 7 /= 0]  
```

O exemplo mais conhecido por demonstrar a expressividade das compreensões de lista é o quicksort.

```C
//Quicksort em C
void quicksort0(int arr[], int a, int b) {
    if (a >= b)
        return;

    int key = arr[a];
    int i = a + 1, j = b;
    while (i < j) {
        while (i < j && arr[j] >= key)
            --j;
        while (i < j && arr[i] <= key)
            ++i;
        if (i < j)
            swap(arr, i, j);
    }
    if (arr[a] > arr[i]) {
        swap(arr, a, i);
        quicksort0(arr, a, i - 1);
        quicksort0(arr, i + 1, b);
    } else {
        quicksort0(arr, a + 1, b);
    }
}
```

Fazendo uso da compreensão de listas podemos fazer o quicksort em apenas duas linhas:

```Haskell
--Quicksort em Haskell
quicksort [] = []  
quicksort (x:xs) = quicksort [a | a <- xs, a <= x] ++ [x] ++ quicksort [a | a <- xs, a > x]  
```

Podemos ver, portanto que utilizando esse recurso o código se torna mais fácil de escrever e até mesmo mais fácil de ler. Vemos também o poder expressivo desse recurso, já que a implementação do algoritmo do quicksort em haskell é muito mais próximo de como se explicaria o algoritmo em linguagem natural do que a versão em C.

## Bibliografia:
1. https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/history.pdf?from=http%3A%2F%2Fresearch.microsoft.com%2F~simonpj%2Fpapers%2Fhistory-of-haskell%2Fhistory.pdf
2. https://wiki.haskell.org/ 
3. http://www.cs.ox.ac.uk/jeremy.gibbons/publications/dgp.pdf
4. https://stackoverflow.com/questions/9558804/quick-sort-in-c
5. https://hackhands.com/lazy-evaluation-works-haskell/
6. http://learnyouahaskell.com/
7. https://wiki.haskell.org/The_Fibonacci_sequence#Using_the_infinite_list_of_Fibonacci_numbers
8. http://zvon.org/other/haskell/Outputprelude/zipWith_f.html
9. https://en.wikipedia.org/wiki/Lazy_evaluation
10. https://wiki.haskell.org/Lazy_evaluation
11. https://hackhands.com/modular-code-lazy-evaluation-haskell/
12. https://en.wikibooks.org/wiki/Haskell/GADT
13. https://kuniga.wordpress.com/2011/09/25/haskell-tipos-de-dados-algebricos/
14. https://stackoverflow.com/questions/29882155/improve-c-fibonacci-series