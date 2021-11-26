module PostsHelper
  def show_notice_if_notice_not_nil(notice)
    notice if notice.present?
  end

  def show_repost(post, status)
    if post.repost.is_archived
      "Postingan tidak tersedia"
    else
      if status == :show_post
        render partial: "posts/show_repost", locals: { post: post }
      else
        render partial: "posts/show_detail_post", locals: { post: post.repost }
      end
    end
  end
end
