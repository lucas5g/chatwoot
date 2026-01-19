<script setup>
import { computed, ref, onMounted, onUnmounted } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
import { useRoute } from 'vue-router';
import { useI18n } from 'vue-i18n';

import Spinner from 'dashboard/components-next/spinner/Spinner.vue';
import ConversationCard from 'dashboard/components-next/Conversation/ConversationCard/ConversationCard.vue';

const { t } = useI18n();
const route = useRoute();
const store = useStore();

const scrollContainerRef = ref(null);

const conversations = useMapGetter(
  'contactConversations/getAllConversationsByContactId'
);
const contactsById = useMapGetter('contacts/getContactById');
const stateInbox = useMapGetter('inboxes/getInboxById');
const accountLabels = useMapGetter('labels/getLabels');
const hasMore = useMapGetter('contactConversations/getHasMore');

const accountLabelsValue = computed(() => accountLabels.value);

const uiFlags = useMapGetter('contactConversations/getUIFlags');
const isFetching = computed(() => uiFlags.value.isFetching);
const isFetchingMore = computed(() => uiFlags.value.isFetchingMore);

const contactConversations = computed(() =>
  conversations.value(route.params.contactId)
);

const canLoadMore = computed(() => hasMore.value(route.params.contactId));

const handleScroll = event => {
  console.log('scroll', { isFetchingMore: isFetchingMore.value, canLoadMore: canLoadMore.value });
  if (isFetchingMore.value || !canLoadMore.value) return;

  const { scrollTop, scrollHeight, clientHeight } = event.target;
  const scrollThreshold = 100;

  if (scrollTop + clientHeight >= scrollHeight - scrollThreshold) {
    store.dispatch('contactConversations/fetchMore', route.params.contactId);
  }
};

onMounted(() => {
  const container = scrollContainerRef.value;
  if (container) {
    container.addEventListener('scroll', handleScroll);
  }
});

onUnmounted(() => {
  const container = scrollContainerRef.value;
  if (container) {
    container.removeEventListener('scroll', handleScroll);
  }
});
</script>

<template>
  <div
    v-if="isFetching"
    class="flex items-center justify-center py-10 text-n-slate-11"
  >
    <Spinner />
  </div>
  <div
    v-else-if="contactConversations.length > 0"
    ref="scrollContainerRef"
    class="flex-1 px-6 py-4 divide-y divide-n-strong overflow-y-auto [&>*:hover]:!border-y-transparent [&>*:hover+*]:!border-t-transparent"
    @scroll="handleScroll"
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
    <div
      v-if="isFetchingMore"
      class="flex items-center justify-center py-4 text-n-slate-11"
    >
      <Spinner />
    </div>
  </div>
  <p v-else class="px-6 py-10 text-sm leading-6 text-center text-n-slate-11">
    {{ t('CONTACTS_LAYOUT.SIDEBAR.HISTORY.EMPTY_STATE') }}
  </p>
</template>
