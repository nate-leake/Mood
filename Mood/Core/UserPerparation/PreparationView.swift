//
//  PreparationView.swift
//  Mood
//
//  Created by Nate Leake on 7/24/25.
//

import SwiftUI

struct SectionView: View {
    var title: String
    var bodyText: [String]
    
    var bodyView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Divider()
            ForEach(bodyText, id: \.self) { line in
                Text(line)
                    .font(.body)
            }
        }
    }
    
    var body: some View {
        bodyView
    }
}

struct PreparationView: View {
    @AppStorage("isMoodFirstTimeLaunch") var isFirstLaunch: Bool = true
    
    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            Color.appPurple.opacity(0.2).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    HStack {
                        VStack(alignment: .leading){
                            Text("welcome to your mood journey")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 1)
                            
                            Text("understanding your data")
                                .font(.subheadline)
                                .opacity(0.6)
                                .bold()
                        }
                        
                        Spacer()
                        HStack {
                            VStack{
                                ContextTile(context:UnsecureContext.defaultContexts[1], frameSize: 40)
                                ContextTile(context:UnsecureContext.defaultContexts[9], frameSize: 40)
                            }
                            VStack {
                                ContextTile(context:UnsecureContext.defaultContexts[3], frameSize: 40)
                                ContextTile(context:UnsecureContext.defaultContexts[4], frameSize: 40)
                            }
                        }
                        Spacer()
                    }
                    
                    Text(
"""
hi there!

before you get started its best to understand how to record your personal information, how its used, and to think about why you want to use this app in the first place.

you’re most likely not here to learn about neuroscience, psychology, or statistics. preparing yourself for how to record, reflect, and act on your data is essential. That’s why we’ve decided to outline the process, drawbacks, and limitations of self reported data for you.
"""
                    )
                    .font(.body)
                    
                    SectionView(
                        title: "what is self reported data?",
                        bodyText: [
"""
self reported data is information that individuals provide about themselves without any outside interference. this is great when it comes to logging your mood.
"""
                        ]
                    )
                    
                    SectionView(
                        title: "the process",
                        bodyText:[
"""
logging your mood at least once a day is recommended, but you can log more or less that that. this is a tool for you to use however you might need. 

when you’re logging your mood, its best to think about how you feel in that moment. don’t put too much pressure on it though. if you forgot to log about something earlier in the day, you can add it when you remember. 

tip: the reason tracking how you feel in the moment is so important is because it reduces bias. if you were very upset about something 3 hours ago, but now you feel great, you’re less likely to log that you were very upset 3 hours ago.
"""
                        ]
                    )
                    
                    SectionView(
                        title: "what are the drawbacks?",
                        bodyText: [
"""
self reported data can be extremely useful when it comes to analysing patterns, triggers, or helpful tools in therapy. that said, self reported data isn't always reliable. it can be hard to be honest with yourself. some users don't like to look back at times they felt uncomfortable or bad, and as a result, they never log negative feelings. The opposite is also true, some users may not log their mood when they feel good because in that moment nothing feels wrong. 

this is why it is important to log your mood no matter how you feel. even if what you feel isn't that intense, or it feels like an extreme, the goal is to reflect. you cannot reflect on data you do not have.
"""
                        ]
                    )
                    
                    SectionView(
                        title: "limitations",
                        bodyText: [
"""
this app is just that - an app. while we try to provide the most intuitive interfaces, we will never be able to capture how you truly feel at any given moment. this is why we always recommend reviewing your data with a mental health professional. gathering insights from your data may not always be fully accurate. our goal in having you log your mood is to have something to reflect on. even if we can't capture the full picture, it can be useful to have something to point to and say "i was feeling this way at this time maybe because of this".
"""
                        ]
                    )
                    
                    SectionView(
                        title: "reminders",
                        bodyText: [
"""
you will occasionally be reminded of the best ways to record, reflect, and act on your data. we know its a lot to remember and easy to forget. you may see more detailed reminders at times. we don't want to overwhelm you. the purpose of this information and its frequency is to ensure that you can make the most informed decisions about your life.
"""
                        ]
                    )
                    
                    HStack{
                        Button() {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isFirstLaunch = false
                            }
                        } label: {
                            Text("i'm ready to continue")
                                .foregroundStyle(.appPurple.optimalForegroundColor())
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.appPurple)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    
                }
                .padding()
            }
            .padding(.top, 1)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PreparationView()
}
