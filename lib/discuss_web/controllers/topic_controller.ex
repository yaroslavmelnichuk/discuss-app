defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic
  alias Discuss.Repo
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def index(conn, _params) do
    topics = Discuss.Repo.all(Discuss.Topic)

    render conn, "index.html", topics: topics
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic created")
          |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{ "id" => topic_id }) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{ "id" => topic_id, "topic" => topic_params}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic updated")
          |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: topic
    end
  end

  def delete(conn, %{ "id" => topic_id }) do
    Repo.get!(Topic, topic_id)
      |> Repo.delete!

      conn
        |> put_flash(:info, "Topic deleted")
        |> redirect(to: Routes.topic_path(conn, :index))
  end
end
