/*************************GO-LICENSE-START*********************************
 * Copyright 2014 ThoughtWorks, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *************************GO-LICENSE-END***********************************/

package com.thoughtworks.go.domain;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import org.junit.Test;

public class StageEventTest {

    @Test
    public void allEventShouldIncludeOthers() {
        assertThat(StageEvent.All.include(StageEvent.Fixed), is(true));
    }

    @Test
    public void eventShouldIncludeItself() {

        assertThat(StageEvent.Fixed.include(StageEvent.Fixed), is(true));
    }

    @Test
    public void shouldNotParseArbitraryStrings() {
        assertThat(StageEvent.valueOf("<script>alert(1)</script>"), is(StageEvent.All));
    }

}
