

package com.monicauditya.june

import com.monicauditya.smollm.SmolLM
import org.koin.core.annotation.ComponentScan
import org.koin.core.annotation.Module
import org.koin.core.annotation.Single

@Module
@ComponentScan("com.monicauditya.june")
class KoinAppModule {

    @Single
    fun provideSmolLM(): SmolLM {
        return SmolLM()
    }
}
