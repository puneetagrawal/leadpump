class FrontDeskDesc < ActiveRecord::Base
  attr_accessible :description, :user_id, :title

  belongs_to :user

  DESC = "I/We hereby understand and acknowledge that the training, programs and events held by the Gym I am attending with this guest pass may expose me to many inherent risks, including accidents, injury, illness, or even death. I/We assume all risk of injuries associated with participation including, but not limited to, falls, contact with other participants, the effects of the weather, including high heat and/or humidity, and all other such risks being known and appreciated by me.
I/We hereby acknowledge my responsibility in communicating any physical and psychological concerns that might conflict with participation in activity. I/We acknowledge that I am physically fit and mentally capable of performing the physical activity I choose to participate in.
After having read this waiver and knowing these facts, and in consideration of acceptance of my participation the Gym furnishing services to me, I agree, for myself and anyone entitled to act on my behalf, to HOLD HARMLESS, WAIVE AND RELEASE
The gym, its officers, agents, employees, organizers, representatives, and successors from any responsibility, liabilities, demands, or claims of any kind a rising out of my participation in the gym training, programs and/or events.By my signature I/We indicate that I/We have read and understand this Waiver of Liability. I am aware that this is a waiver and a release of liability and I voluntarily agree to its terms."
end
