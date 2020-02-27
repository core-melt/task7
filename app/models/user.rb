class User < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  has_many :relationships, dependent: :destroy
  #through: :relationships 「中間テーブルはrelationships」設定
  #source: :follow　relationshipsテーブルのfollow_idを参考にして、followingsモデルにアクセス」
  #user.followings と打つだけで、user が中間テーブル relationships を取得し、その1つ1つの relationship のfollow_idから、「フォローしている User 達」を取得しています
  has_many :followings, through: :relationships, source: :follow

  #フォロワー（フォローされているuser達）をとってくるための記述
  #has_many :relaitonshipsの「逆方向」意味
  #foreign_key: 'follow_id' elaitonshipsテーブルにアクセスする時、follow_idを入口」
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  #through: :reverses_of_relationshipで「中間テーブルはreverses_of_relationship」
  #source: :userで「出口はuser_idね！それでuserテーブルから自分をフォローしているuserをとってきてね！」と設定
  has_many :followers, through: :reverse_of_relationships, source: :user


  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, presence: true
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}

  #フォローしようとしている other_user が自分自身ではないかを検証しています
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  #フォローがあればアンフォロー
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  #self.followings によりフォローしている User 達を取得し、include?(other_user) によって other_user が含まれていないかを確認
  def following?(other_user)
    self.followings.include?(other_user)
  end


  #完全一致
  def self.perfect_matching(search)
      return User.all unless search
      User.where(['name LIKE ?', "#{search}"])
  end

  #前方一致
  def self.forward_match(search)
      return User.all unless search
      User.where(['name LIKE ?', "#{search}%"])
  end

  #後方一致
  def self.backward_match(search)
      return User.all unless search
      User.where(['name LIKE ?', "%#{search}"])
  end

  #部分一致
  def self.part_match(search)
      return User.all unless search
      User.where(['name LIKE ?', "%#{search}%"])
  end

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
end
