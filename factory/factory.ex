defmodule BadgerApi.Factory do
  use ExMachina.Ecto, repo: BadgerApi.Repo
  alias BadgerApi.Accounts
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Badge.Topics
  alias Faker
  alias Recase
  alias Slug


  def writer_factory do
    name = Faker.Name.name()
    %Accounts.Writer{
      name: name,
      password: "password",
      password_hash: Bcrypt.hash_pwd_salt("password"),

      email: sequence(:email, &"#{name |> Recase.to_snake()}#{&1}@email.com"),
      username: sequence(:username, &"@#{name |> Recase.to_snake}#{&1}"),
      description: "#{Faker.Lorem.sentence()}",
      writes_about_topics: for(_ <- 0..4, do: build(:topics))

    }
  end

  def topics_factory do
    title = sequence(:title,  &"#{Faker.Lorem.word()} #{Faker.Lorem.word()} #{&1}")
    %Topics{
      title: title |> Recase.to_title,
      description: "#{Faker.Lorem.sentence()}",
      slug: Slug.slugify(title)

    }
  end

  def articles_factory do

    %Articles{
      title: "#{Faker.Lorem.sentence()}",
      description: "#{Faker.Lorem.sentence(3)}",
      writer: build(:writer),
      content: "#{Faker.Lorem.paragraph(40)}",
      categories: for(_ <- 0..4, do: build(:topics)),

    }
  end

  def topics_map_factory do
    title = sequence(:title,  &"#{Faker.Lorem.word()} #{Faker.Lorem.word()} #{&1}")
    %{
      title: title |> Recase.to_title,
      description: "#{Faker.Lorem.sentence()}",
      slug: Slug.slugify(title)

    }
  end
  def articles_map_factory do
    %{
      title: "#{Faker.Lorem.sentence()}",
      description: "#{Faker.Lorem.sentence(3)}",
      writer: insert(:writer),
      content: "#{Faker.Lorem.paragraph(40)}",
      categories: for(_ <- 0..4, do: build(:topics_map)),

    }
  end
end
