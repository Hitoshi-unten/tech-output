# baseのos
FROM ruby:3.0.3
# RUN apt-get update -y && \
#     apt-get install default-mysql-client nodejs npm vim graphviz -y && \
#     npm uninstall yarn -g && \
#     npm install yarn -g -y && \
#     curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#     apt-get install -y nodejs
RUN apt-get update -y && \
    apt-get install default-mysql-client nodejs npm vim graphviz -y && \
    npm uninstall yarn -g && \
    npm install yarn -g -y && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y libicu-dev && \
    apt-get install -y cmake
# runはビルド時に実行される イメージを作成
# charlock_holmes, ruggedの依存ライブラリ # 鳥本追加
# RUN apt-get install -y libicu-dev cmake
# RUN apt-get install -y cmake
# ルート直下にwebappという名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /webapp
WORKDIR /webapp
# ホストのGemfileとGemfile.lockをコンテナにコピー
ADD Gemfile /webapp/Gemfile
ADD Gemfile.lock /webapp/Gemfile.lock
# bundle installの実行
RUN bundle install -j4
# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
ADD . /webapp
# アセットのプリコンパイル
RUN SECRET_KEY_BASE=placeholder RAILS_ENV=production bundle exec rails assets:precompile \
 && yarn cache clean \
 && rm -rf node_modules tmp/cache
EXPOSE 3000
CMD bash -c "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb"