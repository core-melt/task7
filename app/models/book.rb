class Book < ApplicationRecord
	belongs_to :user
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	#完全一致
	def self.perfect_matching(search)
		return Book.all unless search
		Book.where(['title LIKE ?', "#{search}"])
	end

	#前方一致
	def self.forward_match(search)
		return Book.all unless search
		Book.where(['title LIKE ?', "#{search}%"])
	end

	#後方一致
	def self.backward_match(search)
		return Book.all unless search
		Book.where(['title LIKE ?', "%#{search}"])
	end

	#部分一致
	def self.part_match(search)
		return Book.all unless search
		Book.where(['title LIKE ?', "%#{search}%"])
	end
end
