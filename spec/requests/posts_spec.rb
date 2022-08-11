require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "return an array of posts" do
      user = User.create!(name: "Anna", email: "anna@example.com", password: "password")

      # The reason we create a user and store it in a variable is because we need the newly created user id for the creation of posts.
      # this is due to the user authentication that we put in place

      Post.create!(title: "Monitored bottom-line analyzer", body: "Chambray taxidermy hoodie deep v raw denim organic. Tote bag mlkshk migas. Stumptown humblebrag hashtag. Single-origin coffee umami celiac semiotics xoxo. Vice before they sold out echo. Kinfolk heirloom blue bottle forage. Jean shorts quinoa blue bottle banh mi ethical freegan mlkshk", image: "https://i.picsum.photos/id/302/200/300.jpg?hmac=b5e6gUSooYpWB3rLAPrDpnm8PsPb84p_NXRwD-DK-1I", user_id: user.id)

      Post.create!(title: "Focused bifurcated matrices", body: "Leggings pork belly kinfolk authentic. Gluten-free twee hoodie craft beer cornhole. Disrupt wolf ramps salvia. Slow-carb squid pitchfork diy chia. Kale chips everyday pinterest thundercats schlitz tousled brunch farm-to-table. Heirloom viral hashtag biodiesel cornhole chia.", image: "https://i.picsum.photos/id/131/200/300.jpg?hmac=9q7mRSOguNBFGg_gPPRKlfjNINGjXWeDBTYPP1_gEas", user_id: user.id)

      Post.create!(title: "Digitized neutral local area network", body: "Meh ramps thundercats cold-pressed sustainable green juice. Mlkshk celiac selfies fanny pack. Disrupt plaid everyday yr flexitarian. Kitsch green juice cold-pressed helvetica disrupt meggings. Farm-to-table pour-over before they sold out franzen. Synth meditation deep v ethical scenester vice chillwave banjo. Tofu fanny pack yr neutra aesthetic flexitarian pitchfork.", image: "https://i.picsum.photos/id/852/200/300.jpg?hmac=6IMZOkPF_q5nf8IwfYdfxPUyKnyPL1w8moDjTeMOT5g", user_id: user.id)

      get "/posts"
      posts = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(posts.length).to eq(3)
    end
  end
end
