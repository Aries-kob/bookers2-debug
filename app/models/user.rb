class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  #(フォローする側から)中間テーブルを通してフォローされる側を取得する
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #（フォローされる側から）中間テーブルを通してフォローしてくる側を取得する
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :folloing_user, through: :follower, source: :followed#自分がフォローしてる人
  has_many :follower_user, through: :followed, source: :follower#自分をフォローしている人

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  #ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  #ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  #フォローしていればtrueを返す
  def following?(user)
    followeing_user.include?(user)
  end
end
