defmodule BadgerApiWeb.WritersControllerTest do
  use BadgerApiWeb.ConnCase

  alias BadgerApi.Accounts
  alias BadgerApi.Accounts.Writer
  # alias BadgerApi.Badge.Topics
  import BadgerApi.Factory
  alias BadgerApi.Publications
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Repo
  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    password: "some password_hash",
    username: "@someusername",
    writes_about_topics: ["dragon fruit", "entawak", "figs"]
  }



  @update_attrs %{
    email: "someupdated@email.com",
    name: "some updated name",
    password: "some updated password_hash",
    username: "@someupdatedusername",
    writes_about_topics: ["apples", "bananas", "coconut"]
  }
  @invalid_attrs %{email: nil, name: nil, password: nil, username: nil}

  defp fixture(:writers) do
    {:ok, writer} = Accounts.create_writer(@create_attrs)
    writer
  end

  setup %{conn: conn} do

    {:ok, conn: conn}
  end

  defp put_profile_image(attrs) do
    Map.put(attrs, "avatar", Path.expand("test/static/profile-pic.jpg"))
  end

  describe "index" do
    test "lists all writer", %{conn: conn} do
      conn = get(conn, Routes.writers_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create writers" do
    test "renders writers when data is valid", %{conn: conn} do
      conn = post(conn, Routes.writers_path(conn, :create), writers: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.writers_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some@email.com",
               "name" => "some name",
               "username" => "@someusername"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.writers_path(conn, :create), writers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders data when profile image is sent", %{conn: conn} do
      conn =
        post(conn, Routes.writers_path(conn, :create), writers: put_profile_image(@create_attrs))

      assert json_response(conn, 201)
    end
  end

  describe "account session for writers" do
    setup [:create_writers]

    test "renders sign in page when writer uses their username ", %{
      conn: conn,
      writers: %Writer{id: id} = writers
    } do
      conn =
        post(conn, Routes.writers_path(conn, :login),
          identifier: writers.username,
          password: writers.password
        )

      assert %{
               "id" => ^id,
               "email" => "some@email.com",
               "name" => "some name",
               "username" => "@someusername"
             } = json_response(conn, 200)["data"]
    end

    test "renders sign in page when writers uses their email", %{
      conn: conn,
      writers: %Writer{id: id} = writers
    } do
      conn =
        post(conn, Routes.writers_path(conn, :login),
          identifier: writers.email,
          password: writers.password
        )

      assert %{
               "id" => ^id,
               "email" => "some@email.com",
               "name" => "some name",
               "username" => "@someusername"
             } = json_response(conn, 200)["data"]
    end
  end

  # TODO implement this for writers
  describe "interested writers" do
    setup [:create_writers, :create_writers_with_interests]

    test "returns a list of writers based on your interest in paginated form", %{
      conn: conn,
      writer_one: writer_one,
      writer_two: writer_two,
      writer_three: writer_three,
      writers: %Writer{id: _id} = writers
    } do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)

      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      writers = [writer_one, writer_two, writer_three]

      conn =
        get(
          conn,
          Routes.writers_path(conn, :list_writers_by_interest,
            interests: ["south africa", "jamaica"]
          )
        )

      assert json_response(conn, 200)["data"] == writers
    end
  end

  describe "update writers" do
    setup [:create_writers]

    test "renders writers when data is valid", %{conn: conn, writers: %Writer{id: id} = writers} do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.writers_path(conn, :update, writers), writers: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.writers_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "someupdated@email.com",
               "name" => "some updated name",
               "username" => "@someupdatedusername"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, writers: writers} do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)
      conn = put(conn, Routes.writers_path(conn, :update, writers), writers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete writers" do
    setup [:create_writers]

    test "deletes chosen writers", %{conn: conn, writers: writers} do
      {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writers)
      conn = put_req_header(conn, "authorization", "bearer: " <> token)

      conn = delete(conn, Routes.writers_path(conn, :delete, writers))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.writers_path(conn, :show, writers))
      end
    end
  end

  describe "order writers by specific goals" do
    setup [:sign_in_writers]
    test "order writers by most popular writers in certain list of topics",  %{conn: conn, topics: topics}do
      conn = get(conn, Routes.writers_path(conn, :topics_popularity, topics: topics))
      assert response(conn, 200)
    end
  end
  defp create_writers(_) do
    writers = fixture(:writers)
    {:ok, writers: writers}
  end

  def popularity_topics_fixture() do
    topics_list = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
    # create 10 writers
    writers_list = build_list(10, :writer_map, writes_about_topics: []) |> Enum.map(&Accounts.create_writer!/1)


    zipped_writers = Enum.zip([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], writers_list)
    for {index, writer} <- zipped_writers do

      build_list(index, :articles_map, writer_id: writer.id, categories: [Enum.at(topics_list, index)])
      |> Enum.map(&Publications.create_articles/1)

    end
    articles_list = Repo.all(Publications.Articles) |> Repo.preload(:categories)
    {:ok, topics_list,  articles_list, writers_list}

  end
  defp sign_in_writers(%{conn: conn} = connection) do
    {:ok, topics, _, ordered_writers} = popularity_topics_fixture()
    {:ok, writer} = Accounts.create_writer(%{name: "Name Man", username: "@usernameMan", password: "password", email: "usernameman@gmail.com", })
    {:ok, token, _} = BadgerApi.Auth.Guardian.encode_and_sign(writer)

    conn =
      put_req_header(conn, "accept", "application/json")
      |> put_req_header("authorization", "bearer: " <> token)
      {:ok, conn: conn}

      {:ok, conn: conn, topics: topics, ordered_writers: ordered_writers}
  end

  defp create_writers_with_interests(_) do
    {:ok, nelson_mandella} =
      Accounts.create_writer(%{
        name: "Nelson Mandella",
        username: "@nelsonmandella",
        password: "password",
        email: "nelsonmandella@gmail.com",
        writes_about_topics: ["south africa"]
      })

    {:ok, marcus_garvey} =
      Accounts.create_writer(%{
        name: "Marcus Garvey",
        username: "@marcusgarvey",
        password: "password",
        email: "marcusgarvey@gmail.com",
        writes_about_topics: ["jamaica"]
      })

    {:ok, martin_luther_king} =
      Accounts.create_writer(%{
        name: "Martin Luther",
        username: "@martinluther",
        password: "password",
        email: "martinluther@gmail.com",
        writes_about_topics: ["united states of america"]
      })

    {:ok,
     writer_one: nelson_mandella, writer_two: marcus_garvey, writer_three: martin_luther_king}
  end
end
