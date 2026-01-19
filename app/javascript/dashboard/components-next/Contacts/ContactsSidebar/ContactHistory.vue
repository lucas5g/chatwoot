<script setup>
import { computed, ref } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { useRoute } from 'vue-router';
import { useI18n } from 'vue-i18n';

import Spinner from 'dashboard/components-next/spinner/Spinner.vue';
import ConversationCard from 'dashboard/components-next/Conversation/ConversationCard/ConversationCard.vue';
import IntersectionObserver from 'dashboard/components/IntersectionObserver.vue';

const { t } = useI18n();
const route = useRoute();

const conversations = useMapGetter(
  'contactConversations/getAllConversationsByContactId'
);
const contactsById = useMapGetter('contacts/getContactById');
const stateInbox = useMapGetter('inboxes/getInboxById');
const accountLabels = useMapGetter('labels/getLabels');
const store = useStore();

const accountLabelsValue = computed(() => accountLabels.value);
const uiFlags = useMapGetter('contactConversations/getUIFlags');

const isFetching = computed(() => uiFlags.value.isFetching);

const contactConversations = computed(() =>
  conversations.value(route.params.contactId)
);

const page = ref(1);

const loadMoreConversations = async () => {
  if (isFetching.value) {
    return;
  }
  const { contactId } = route.params;
  if (!contactId) {
    return;
  }
  page.value += 1;
  store.dispatch('contactConversations/get', { contactId, page: page.value });
};

const hasMore = computed(() => {
  const currentCount = contactConversations.value.length;
  // If we have less than 10 (page size) * page, we reached the end
  // But since we can't reliably know total count, we can check if the current length is a multiple of 10
  // A better approach in this codebase usually involves checking if the last fetch returned < page size
  // For now, assuming if we have conversations and not fetching, we can try to load more
  // Or simply rely on the fact that if we scroll down we trigger it.
  // Let's rely on checking if we have at least page * 10 items? No, that breaks if items are added.
  // Best check: if the total count < page * 10, then we probably exhausted it.
  // However, contactConversations is a getter that might not reflect exact server state if we use push.
  // A simple heuristic: if return count < 10, stop. But we don't have access to last fetch count here directly.
  // We can just try to fetch.
  return isFetching.value || currentCount >= page.value * 10;
});
</script>

<template>
  <div
    v-if="isFetching && !contactConversations.length"
    class="flex items-center justify-center py-10 text-n-slate-11"
  >
    <Spinner />
  </div>
  <div
    v-else-if="contactConversations.length > 0"
    class="px-6 py-4 divide-y divide-n-strong [&>*:hover]:!border-y-transparent [&>*:hover+*]:!border-t-transparent"
  >
    <ConversationCard
      v-for="conversation in contactConversations"
      :key="conversation.id"
      :conversation="conversation"
      :contact="contactsById(conversation.meta.sender.id)"
      :state-inbox="stateInbox(conversation.inboxId)"
      :account-labels="accountLabelsValue"
      class="rounded-none hover:rounded-xl hover:bg-n-alpha-1 dark:hover:bg-n-alpha-3"
    />
    <div v-if="hasMore" class="flex flex-col items-center justify-center py-4 gap-2">
      <Spinner v-if="isFetching" />
      <IntersectionObserver
        class="w-full h-20"
        @observed="loadMoreConversations"
      />
    </div>
    <p
      v-else
      class="py-4 text-xs text-center text-n-slate-9 dark:text-n-slate-8"
    >
      {{ t('CONTACTS_LAYOUT.SIDEBAR.HISTORY.END_OF_HISTORY') }}
    </p>
  </div>
  <p v-else class="px-6 py-10 text-sm leading-6 text-center text-n-slate-11">
    {{ t('CONTACTS_LAYOUT.SIDEBAR.HISTORY.EMPTY_STATE') }}
  </p>
</template>
