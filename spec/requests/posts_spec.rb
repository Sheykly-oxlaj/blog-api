require "rails_helper"

RSpec.describe "Posts", type: :request do
  ################## test for the posts index action#############
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

  ################## test for the posts show action   #############
  describe "GET /posts/:id" do
    it "should return a hash with the appropiate attributes" do
      user = User.create!(name: "Anna", email: "anna@example.com", password: "password")

      Post.create!(title: "I am tired", body: "I am really, really tired, and just want to take a nap.", image: "https://www.cnet.com/health/sleep/how-to-nap-without-ruining-your-sleep/", user_id: user.id)

      post_id = Post.first.id   #we need to declare this as a variable, because we do not know the id of the post being created
      get "/posts/#{post_id}.json"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("I am tired")
      expect(post["body"]).to eq("I am really, really tired, and just want to take a nap.")
      expect(post["image"]).to eq("https://www.cnet.com/health/sleep/how-to-nap-without-ruining-your-sleep/")
    end
  end

  ################## test for the posts create action   #############
  # Due to user_authentication(?) we need to make a user, then generate a jwt by copying the code from app/controllers/sessions_controller.rb
  describe "POST /posts" do
    it "should create a post" do
      user = User.create!(name: "Anna", email: "anna@example.com", password: "password")
      # Code to generate jwt
      jwt = JWT.encode(
        {
          user_id: user.id, # the data to encode
          exp: 24.hours.from_now.to_i, # the expiration time
        },
        Rails.application.credentials.fetch(:secret_key_base), # the secret key
        "HS256" # the encryption algorithm
      )
      #happy path lines 59-70
      post "/posts", params: {
                       title: "I am tired",
                       body: "I am really, really tired, and just want to take a nap.",
                       image: "https://www.cnet.com/health/sleep/how-to-nap-without-ruining-your-sleep/",
                       user_id: user.id,
                     },
                     headers: { "Authorization" => "Bearer #{jwt}" }  #jwt is a variable from line 50

      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("I am tired")
    end

    #sad path for invalid data
    it "should return an error code for invalid data" do
      user = User.create!(name: "Anna", email: "anna@example.com", password: "password")
      jwt = JWT.encode(
        {
          user_id: user.id,
          exp: 24.hours.from_now.to_i,
        },
        Rails.application.credentials.fetch(:secret_key_base),
        "HS256"
      )
      post "/posts", params: {
                       title: "I am tired",
                       body: "I am really, really tired, and just want to take a nap.",
                     },
                     headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(418)
    end

    #sad path
    it "should return an error without a jwt" do
      post "/posts", params { }
    end
  end
end
