# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#reviews
review_1 = dog_bone.reviews.create(title: "This stunk", content: "super smelly", rating: 1)
review_3 = dog_bone.reviews.create(title: "Not amazing, but not terrible", content: "meh", rating: 3)
review_5 = dog_bone.reviews.create(title: "Pretty great", content: "My dog loved it and it kept him occupied for hours", rating: 5)
review_2 = pull_toy.reviews.create(title: "This blew my mind", content: "so simple, but so great", rating: 5)
review_4 = pull_toy.reviews.create(title: "Broke immediately", content: "Snappy snappy", rating: 1)
review_8 = pull_toy.reviews.create(title: "Stretchy stretchy", content: "My dogs love it!", rating: 4)
review_6 = tire.reviews.create(title: "Slippery!", content: "Traction in the wet is very low", rating: 2)
review_7 = tire.reviews.create(title: "Tough", content: "My commute goes through lots of glass and I no longer get flats on the regular", rating: 5)
review_9 = tire.reviews.create(title: "Ok", content: "Not sure if the extra weight is worth the puncture resistance", rating: 3)
