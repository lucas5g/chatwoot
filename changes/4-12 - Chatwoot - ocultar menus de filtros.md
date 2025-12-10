/home/lucas/projects/chatwoot/app/javascript/dashboard/components/widgets/conversation/ConversationBasicFilter.vue
import { useAdmin } from 'dashboard/composables/useAdmin';
const { isAdmin } = useAdmin();
    <NextButton
      v-if="isAdmin"
      v-tooltip.right="$t('CHAT_LIST.SORT_TOOLTIP_LABEL')"
      icon="i-lucide-arrow-up-down"
      slate
      faded
      xs
      @click="toggleDropdown()"
    />

app/javascript/dashboard/components/ChatListHeader.vue
import { useAdmin } from 'dashboard/composables/useAdmin';
const { isAdmin } = useAdmin();
<div v-else-if="isAdmin" class="relative">
  <NextButton
    id="toggleConversationFilterButton"
    v-tooltip.right="$t('FILTER.TOOLTIP_LABEL')"
    icon="i-lucide-list-filter"
    slate
    xs
    faded
    @click="emit('filtersModal')"
  />
  <div
    id="conversationFilterTeleportTarget"
    class="absolute z-50 mt-2"
    :class="{ 'ltr:right-0 rtl:left-0': isOnExpandedLayout }"
  />
</div>