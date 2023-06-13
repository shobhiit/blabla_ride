namespace :rpush do
  desc "Create Rpush Android app"
  task :android_app, [:name, :connections, :environment, :auth_key] => [:environment] do |_, args|
    # Set default values if not provided
    args.with_defaults(connections: 1, environment: "production")

    success = Rpush::Gcm::App.create(
      name: args.name,
      connections: args.connections.to_i,
      environment: args.environment,
      type: "Rpush::Client::ActiveRecord::Gcm::App",
      auth_key: args.auth_key
    )

    if success
      puts "Rpush Android app created successfully"
    else
      puts "Failed to create Rpush Android app"
    end
  end


  # desc "Create Rpush iOS app"
  # task :ios_app, [:name, :connections, :environment, :auth_key, :certificate] => [:environment] do |_, args|
  #   success = Rpush::Apn::App.create(name: args.name, connections: args.connections.to_i, environment: args.environment, type: "Rpush::Client::ActiveRecord::Apn::App", auth_key: args.auth_key, certificate: args.certificate)
  #   if success
  #     puts "Rpush iOS app created successfully"
  #   else
  #     puts "Failed to create Rpush iOS app"
  #   end
  # end
end
