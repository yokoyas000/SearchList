## Data Layer

- RepositoryProtocol(DataSourceProtocol)
    - DataLayerの外とのやりとりはこの Protocol 経由で行うことで疎結合、テスタビリティを高める
    - [GithubRepositoryDataSource](https://github.com/yokoyas000/SearchList/blob/master/SearchList/DataSource/GithubRepositoryDataSource.swift)
    
- XxxxAPI
    - RepositoryProtocolの実装側
    - API個別に定義してる。
    - １箇所にまとめると「今利用しているAPIに本当に必要な情報はなにか」を見落としやすいので分割したい
    - etc.) [GithubSearchRepositoriesAPI](https://github.com/yokoyas000/SearchList/blob/master/SearchList/DataSource/API/GithubSearchRepositoriesAPI.swift)
    

- APIClient / HTTPClient
    - XxxxAPI が内部で利用している。通信処理を担う部分
    - Almofire など通信ライブラリが必要な場合、ライブラリへの依存はこの１箇所で留めることで、ライブラリの着脱を行いやすくする
    - [GithubAPIClient](https://github.com/yokoyas000/SearchList/blob/master/SearchList/DataSource/API/GithubAPIClient/GithubAPIClient.swift)

## Domain Layer

- UseCaseProtocol
    - Presantation Layer からの指示は Protocol 経由で行うことで疎結合、テスタビリティを高める
    
- XxxxUseCase
    - 外部(大抵、Presentation Layer)から Protocol 経由で指示を受け処理を行い、Store の状態を変更する
    - 状態管理(現在の状態を見てふさわしい処理を割り振る)はここで行う
    -  [SearchGithubRepositoriesUseCase](https://github.com/yokoyas000/SearchList/blob/master/SearchList/Feature/SearchGithubRepositories/Domain/SearchGithubRepositoriesUseCase.swift)

- Store
    - 状態を保持し、外部(Presentation Layer)へ通知する役割
    - UseCase によって状態を変えられ、 Obsever パターンで外部へ通知を行う
    - [Store](https://github.com/yokoyas000/SearchList/blob/master/SearchList/Common/Store.swift)
    
## Presentation Layer

- [User Interface 全般](https://github.com/yokoyas000/SearchList/tree/master/SearchList/Feature/SearchGithubRepositories/UserInterface)

- View
    - 画面の構築、表示、更新
    - 主に、UIKit, xib, storyboard が担っている部分
- Controller
    - ユーザー入力を Domain Layer へ伝える(変換する)
- Renderer(Presenter)
    - Store の変更(= Domain Layer の変更)を受け取り、結果を人間が見やすい形へ変換してViewを更新する

## ViewControlelr について
- ViewController は、強いて言えば Presentation Layer の位置にあるが、基本は Comporserに徹する(= MV*の関係作り を行う)
- ViewController はすでに画面のライフサイクル管理という重い責務があるため、これ以上仕事を増やさないために、Comporser役とした

## 画面遷移について

- 画面遷移はコードにより行なっています
    - segueで遷移すると下記の問題があります
        - 値渡しや、遷移時に処理(ログ記録など)を混ぜたい場合に不便
        - storyboardで画面遷移する場合、複数人開発ではコンフリクトが発生しやすく、スケールしない
- [Navigator](https://github.com/yokoyas000/SearchList/blob/master/SearchList/Common/Navigator.swift)
- [SearchGithubRepositoriesNavigator](https://github.com/yokoyas000/SearchList/blob/master/SearchList/Feature/SearchGithubRepositories/UserInterface/SearchGithubRepositoriesNavigator.swift)
    - Storeの変更を監視して、任意のタイミングで Navigator を利用して画面遷移している
