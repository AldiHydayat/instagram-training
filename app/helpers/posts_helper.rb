module PostsHelper
  def show_repost(post)
    if post.repost.is_archived
      "Postingan tidak tersedia"
    else
      render partial: "posts/show_post", locals: { post: post.repost }
    end
  end
end
